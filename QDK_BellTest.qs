namespace bell {
	open Microsoft.Quantum.Arrays;
	open Microsoft.Quantum.Canon;
	open Microsoft.Quantum.Convert;
	open Microsoft.Quantum.Intrinsic;
	open Microsoft.Quantum.Math;
	open Microsoft.Quantum.Measurement;
	
	operation InitBellState(q1 : Qubit, q2: Qubit) : Unit is Adj {
		X(q1);
		X(q2);
		H(q1);
		CNOT(q1, q2);
	}
	
	operation BellsInequalityAB() : (Bool, Bool) {
		using ((q1, q2) = (Qubit(), Qubit())) {
			InitBellState(q1, q2);
			Rz(PI() / 3.0, q2);
			return (IsResultOne(MResetX(q1)), IsResultOne(MResetX(q2)));
		}
	}
	
	operation BellsInequalityAC() : (Bool, Bool) {
		using ((q1, q2) = (Qubit(), Qubit())) {
			InitBellState(q1, q2);
			Rz(2.0 * PI() / 3.0, q2);
			return (IsResultOne(MResetX(q1)), IsResultOne(MResetX(q2)));
		}
	}
	
	operation BellsInequalityBC() : (Bool, Bool) {
		using ((q1, q2) = (Qubit(), Qubit())) {
			InitBellState(q1, q2);
			Rz(PI() / 3.0, q1);
			Rz(2.0 * PI() / 3.0, q2);
			return (IsResultOne(MResetX(q1)), IsResultOne(MResetX(q2)));
		}
	}
	
	operation Run(name : String, fn: (Unit => (Bool, Bool))) : Double {
		let runs = 4096;
		mutable results = [0, 0, 0, 0];
		for (i in 0..runs)
		{
			let (r1, r2) = fn();
			if (not r1 and not r2) { set results w/= 0 <- results[0] + 1; }
			if (not r1 and r2) { set results w/= 1 <- results[1] + 1; }
			if (r1 and not r2) { set results w/= 2 <- results[2] + 1; }
			if (r1 and r2) { set results w/= 3 <- results[3] + 1; }
		}
		let p00 = IntAsDouble(results[0]) / IntAsDouble(runs);
		let p01 = IntAsDouble(results[1]) / IntAsDouble(runs);
		let p10 = IntAsDouble(results[2]) / IntAsDouble(runs);
		let p11 = IntAsDouble(results[3]) / IntAsDouble(runs);
		let p = p00 - p01 - p10 + p11;
		Message($"|00> {p00}");
		Message($"|01> {p01}");
		Message($"|10> {p10}");
		Message($"|11> {p11}");
		Message($"{name} {p}");
		Message("");
		return p;
	}
	
	operation RunAB(name : String) : Double {
		return Run(name, BellsInequalityAB);
	}
	operation RunAC(name : String) : Double {
		return Run(name, BellsInequalityAC);
	}
	operation RunBC(name : String) : Double {
		return Run(name, BellsInequalityBC);
	}
}