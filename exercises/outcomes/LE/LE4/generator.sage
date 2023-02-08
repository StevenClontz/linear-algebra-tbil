load("library/common.sage")

class Generator(BaseGenerator):
    def data(self):
        # infinitely-many solutions
        # create a 3x4 or 4x3 non-invertible matrix
        rows = choice([3,4])
        columns = 7-rows
        rank = randrange(2,columns)
        A = CheckIt.simple_random_matrix_of_rank(rank,rows=rows,columns=columns)
        image_basis = [A.column(p) for p in A.pivots()]
        coeffs = [
            randrange(1,4)*choice([-1,1])
            for _ in range(rank)
        ]
        lin_combo = column_matrix(sum([
            coeffs[p]*image_basis[p]
            for p in range(rank)
        ]))
        m = A.augment(lin_combo, subdivide=True)
        if choice([True,False]):
            system_label = "system"
            system = CheckIt.latex_system_from_matrix(m)
        else:
            system_label = "vec_eq"
            system = vectorEquation(m)
        solset = CheckIt.latex_solution_set_from_matrix(m)
        simplified_system = CheckIt.latex_system_from_matrix(m.rref())
        
        return {
            system_label: system,
            "simplified_system": simplified_system,
            "solset": solset,
        }
