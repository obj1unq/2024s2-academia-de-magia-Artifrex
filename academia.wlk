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


}

class Mueble {

	const property cosasGuardadas = #{}
	const precio

	method agregar(cosa) {
		cosasGuardadas.add(cosa)
	}

	method tieneGuardada(cosa) {
		return cosasGuardadas.contains(cosa)
	}

	method sePuedeGuardar(cosa)

	method utilidad() {
		return self.utilidadDeCosasGuardadas() / precio
	}

	method utilidadDeCosasGuardadas() {
		return cosasGuardadas.sum({cosa => cosa.utilidad()})
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
}

class GabineteMagico inherits Mueble{

	override method sePuedeGuardar(cosa) {
		return cosa.esMagica()
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
