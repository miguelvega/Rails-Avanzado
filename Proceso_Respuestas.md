# Proceso y Respuestas de la Actividad

Clonamos el respotorio dado en la actividad y nos dirigimos al siguiente directorio de myrottenpotatoes y ejecutamos el comando `bin/rails server` para iniciar nuestro servidor web local que escucha en un puerto específico (por defecto, el puerto 3000), acedemos a nuestra aplicación a través de un navegador web visitando http://localhost:3000, nos muestra un error, ActiveRecord::StatementInvalid nos indica que hay un problema con una consulta SQL en nuestra aplicación Rails.

![2](https://github.com/miguelvega/Rails-Avanzado/assets/124398378/1727abfa-82d2-464c-b6de-af1aba732084)



Por tal motivo al dirigirnos a la terminal nos muestra 500 Internal Server Error que es un código de respuesta de error del servidor que indica que el servidor encontró una condición inesperada que le impidió cumplir con la solicitud debido a que estámos intentando acceder a la tabla moviegoers y Rails no la encuentra en la base de datos. Ademas el error sugiere que el problema está en el método set_current_user ubicado en el archivo Desarrollo-software-2023/Semana7/myrottenpotatoes/app/controllers/application_controller.rb

![3](https://github.com/miguelvega/Rails-Avanzado/assets/124398378/8f7c2696-a34c-4a54-ac31-94209d8b4b09)

Al movernos a la carpeta migrate en el directorio db vemos que tenemos un archivo de migración denominado 20231003234846_create_movies.rb. Escribimos el comando rails generate migration CreateMoviegoers para generar un nuevo archivo de migración en el directorio db/migrate con un esquema básico para crear la tabla moviegoers. El nombre del archivo se generará automáticamente y contendrá una marca de tiempo para garantizar un orden correcto de ejecución de migraciones.

![5](https://github.com/miguelvega/Rails-Avanzado/assets/124398378/19eb9829-b8fa-45ae-915a-f0ad00764e85)

Sin embargo, todavia no hemos ejecutado la migración para aplicar los cambios a la base de datos, para ellos debemos ejecutar el comando `rails db:migrate.

![8](https://github.com/miguelvega/Rails-Avanzado/assets/124398378/9b1910ce-ec48-4641-88e0-b4f774257ae4)

Observamos el archivo schema.rb que contiene información sobre la estructura de la base de datos, incluyendo las tablas y sus columnas. Este archivo se genera automáticamente a partir de las migraciones y refleja el estado actual de la base de datos. Podemos observar en la siguiente imagen que tenemos dos tablas, entre ellas la tabla moviegoer y con ello solucionariamos el error anterior.

![9](https://github.com/miguelvega/Rails-Avanzado/assets/124398378/9ee6796b-d53c-41cd-9d1d-e9c87f84942d)

Ejecutamos el comando bin/rails server nuevamente y notamos un nuevo error, esta vez relacionado a un error de sintaxis en el archivo app/models/movie.rb, esto se puede apreciar en la siguiente imagen.

![10](https://github.com/miguelvega/Rails-Avanzado/assets/124398378/21d333b5-434f-46ed-a9fe-50ef806d38a2)

Lo solucionamos editando el archivo movie.rb, quedandonos de la siguiente manera.

![11](https://github.com/miguelvega/Rails-Avanzado/assets/124398378/9077b67d-c2c6-4d13-9b64-cbd5acc81adc)


Ejecutamos el comando bin/rails server y podemos ver la siguiente vista  a traves de un navegador web, esta vista lo maneja los archivos index.html.haml (representa la vista de la lista de todas las películas), new.html.haml (se utiliza para mostrar el formulario de creación de una nueva película), show.html.haml (.muestra los detalles de una película específica). Estas vistas son componentes esenciales para la interacción del usuario con la aplicación.

![13](https://github.com/miguelvega/Rails-Avanzado/assets/124398378/c0600d41-df01-4b6a-a22c-e09cddbe0297)

Las validaciones en Rails son mecanismos que permiten asegurar que los datos almacenados en la base de datos cumplen con ciertos criterios antes de ser guardados.Si una validación falla, el objeto no se guardará y se agregarán errores al objeto para indicar qué validaciones fallaron y por qué. Estas validaciones ayudan a mantener la integridad, seguridad, la experiencia del usuario, el mantenimiento de las reglas de negocio y la consistencia de los datos en la aplicación.

Por ello, para estudiar este mecanismo editaremos el archivo `movie.rb` con el siguiente codigo:

```
class Movie < ActiveRecord::Base
    def self.all_ratings ; %w[G PG PG-13 R NC-17] ; end #  shortcut: array of strings
    validates :title, :presence => true
    validates :release_date, :presence => true
    validate :released_1930_or_later # uses custom validator below
    validates :rating, :inclusion => {:in => Movie.all_ratings},
        :unless => :grandfathered?
    def released_1930_or_later
        errors.add(:release_date, 'must be 1930 or later') if
        release_date && release_date < Date.parse('1 Jan 1930')
    end
    @@grandfathered_date = Date.parse('1 Nov 1968')
    def grandfathered?
        release_date && release_date < @@grandfathered_date
    end
end

```
Ejecutamos el comando rails console y comprobamos los resultados creando una nueva instancia de la clase Movie con atributos específicos, incluyendo un título en blanco (''), una clasificación ('RG'), y una fecha de lanzamiento anterior a 1930 ('1929-01-01').

![19](https://github.com/miguelvega/Rails-Avanzado/assets/124398378/45d3b1b9-63f4-4d13-9a4d-3b3cc3fe1e6f)

Editamos el archivo movie.rb y comprobamos que el siguiente codigo ilustra cómo utilizar este mecanismo para “canonicalizar” (estandarizar el formato de) ciertos campos del modelo antes de guardar el modelo.

``
class Movie < ActiveRecord::Base
    before_save :capitalize_title
    def capitalize_title
        self.title = self.title.split(/\s+/).map(&:downcase).map(&:capitalize).join(' ')
    end
end


```
Con lo cual el metodo `capitalize_title` se encargará de dividir las palabras en el título, convertirlas a minúsculas y luego capitalizar la primera letra de cada palabra antes de unirlas nuevamente. Ejecutamos el comando rails console y comprobamos los resultados creando una nueva instancia de la clase Movie con atributos específicos, incluyendo un título ('STAR wars'), una fecha de lanzamiento ('127-5-1977) y una clasificación ('PG'). Al escribir m.title en la consola deberiamos ver que el título se ha estandarizado y capitalizado como "Star Wars".

![21](https://github.com/miguelvega/Rails-Avanzado/assets/124398378/a15055a8-9fb3-44ea-94c9-709738121e07)

ejecutamos bin/rails server y podemos apreciar qie se agrego un nuevo registro en la tabla de peliculas.

```
Star Wars 	PG 	1977-05-27 00:00:00 UTC 	More about Star Wars

```
 
