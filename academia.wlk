class Academia {
	const muebles = #{}

	method guardar(cosa) {
		self.validarGuardar(cosa)
		self.guardarEnMueble(cosa)
	}

	method guardarEnMueble(cosa) {
		self.mueblesAptosPara(cosa).anyOne().agregar(cosa)
	}

	method mueblesAptosPara(cosa) {
		return muebles.filter({mueble => mueble.sePuedeGuardar(cosa)})
	}

	method validarGuardar(cosa) {
		if (!self.puedeGuardar(cosa)) {
			self.error("No puedo guardar " + cosa)
		}
	}

	method puedeGuardar(cosa) {
		return !self.estaGuardada(cosa) and self.hayMuebleParaGuardar(cosa)
	}

	method estaGuardada(cosa) {
		return muebles.any({mueble => mueble.tieneGuardada(cosa)})
	}

	method hayMuebleParaGuardar(cosa) {
		return muebles.any({mueble => mueble.sePuedeGuardar(cosa)})
	}

	method dondeEstaGuardada(cosa) {
		return muebles.find({mueble => mueble.tieneGuardada(cosa)})
	}

	method cosasMenosUtiles() {
		return muebles.map({mueble => mueble.cosaMenosUtil()}).asSet()
	}

	method cosaMasInutil() {
		return self.cosasMenosUtiles().min({cosa => cosa.utilidad()})
	}

	method marcaMenosUtil() {
		return self.cosaMasInutil().marca()
	}

	method eliminarCosasInutilesNoMagicas() {
		self.validarEliminar()
		self.cosasMenosUtiles().forEach({cosa => })
	}

}

class Mueble {

	const property cosasGuardadas = #{}
	
	method agregar(cosa) {
		cosasGuardadas.add(cosa)
	}

	method tieneGuardada(cosa) {
		return cosasGuardadas.contains(cosa)
	}

	method sePuedeGuardar(cosa)

	method utilidad() {
		return self.utilidadDeCosasGuardadas() / self.precio()
	}

	method utilidadDeCosasGuardadas() {
		return cosasGuardadas.sum({cosa => cosa.utilidad()})
	}

	method precio()

	method cosaMenosUtil() {
		return cosasGuardadas.min({cosa => cosa.utilidad()})
	}
}

class Armario inherits Mueble {

	var capacidadMaxima

	method capacidadMaxima(_capacidadMaxima) {
		capacidadMaxima= _capacidadMaxima
	}

	override method sePuedeGuardar(cosa) {
		return capacidadMaxima >= (self.cantCosasGuardadas() + 1)
	}

	method cantCosasGuardadas() {
		return cosasGuardadas.size()
	}

	override method precio() {
		return 5 * capacidadMaxima
	}
}

class GabineteMagico inherits Mueble{

	const precio

	override method sePuedeGuardar(cosa) {
		return cosa.esMagica()
	}

	override method precio() {
		return precio
	}

}

class Baul inherits Mueble {

	const volumenMaximo

	override method sePuedeGuardar(cosa) {
		return volumenMaximo >= (self.volumenTotalGuardado() + cosa.volumen())
	}

	method volumenTotalGuardado() {
		return cosasGuardadas.sum({cosa => cosa.volumen()})
	}

	override method precio() {
		return volumenMaximo + 2
	}

	override method utilidad() {
		return super() + if (self.todasSonReliquias()) 2 else 0
	}

	method todasSonReliquias() {
		return cosasGuardadas.all({cosa => cosa.esReliquia()})
	}

}

class BaulMagico inherits Baul {

	override method precio() {
		return super() * 2
	}

	override method utilidad() {
		return super() + self.cantCosasMagicasGuardadas()
	}

	method cantCosasMagicasGuardadas() {
		return cosasGuardadas.count({cosa => cosa.esMagica()})
	}
}

class Cosa {
	const property marca
	const property volumen
	const property esMagica
	const property esReliquia

	method utilidad() {
		return volumen + self.loQueAportaLaMarca() + self.loQueAportaSiEsMagica() + self.loQueAportaSiEsReliquia()
	}

	method loQueAportaLaMarca() {
		return marca.utilidadQueAportaA(self)
	}

	method loQueAportaSiEsMagica() {
		return if (self.esMagica()) 3 else 0
	}

	method loQueAportaSiEsReliquia() {
		return if (self.esMagica()) 5 else 0
	}
}

object cuchuflito{

	method utilidadQueAportaA(cosa) {
		return 0
	}
}

object acme {

	method utilidadQueAportaA(cosa) {
		return cosa.volumen() / 2
	}
}

object fenix {

	method utilidadQueAportaA(cosa) {
		return if (cosa.esReliquia()) 3 else 0
	}
}
