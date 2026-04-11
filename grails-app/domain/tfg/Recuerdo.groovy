package tfg

class Recuerdo {
    byte[] foto
    String texto
    Date fecha
    String etiqueta

    static belongsTo = [album: Album]

    static constraints = {
        foto nullable: false
        texto blank: false
        fecha nullable: false
        etiqueta nullable: true
    }

    static mapping = {
        foto sqlType: 'mediumblob'
    }
}