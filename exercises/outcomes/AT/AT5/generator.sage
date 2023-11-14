load("library/common.sage")

class Generator(BaseGenerator):
    def data(self):
        var('x1 x2 x3 y1 y2 y3 c d x y')
        v1 = vector([x1,y1])
        v2 = vector([x2,y2])
        v3 = vector([x3,y3])
        v = vector([x,y])
        vectorsimplify = lambda v : vector([simplify(expand(x)) for x in v])
        def verify(prop,plus,times):
            try:
                if prop == "add_assoc":
                    LHS = plus(v1,plus(v2,v3))
                    RHS = plus(plus(v1,v2),v3)
                elif prop == "add_comm":
                    LHS = plus(v1,v2)
                    RHS = plus(v2,v1)
                elif prop == "mul_assoc":
                    LHS = times(c*d,v)
                    RHS = times(c,times(d,v))
                elif prop == "mul_id":
                    LHS = times(1,v)
                    RHS = v
                elif prop == "dist_v":
                    LHS = times(c,plus(v1,v2))
                    RHS = plus(times(c,v1),times(c,v2))
                elif prop == "dist_s":
                    LHS = times(c+d,v)
                    RHS = plus(times(c,v),times(d,v))
                LHS = vectorsimplify(LHS)
                RHS = vectorsimplify(RHS)
                assert LHS == RHS
            except AssertionError:
                raise Exception(f"failed on {prop} {LHS} {RHS}")
            return vectorsimplify(LHS)

        n = randrange(6)
        if n==0:
            m1=randrange(2,5)
            m2=randrange(1,4)
            plus = lambda v1,v2: vector([m1*v1[0]+v2[0], v1[1]+m2*v2[1]])
            times = lambda c,v : vector([c*v[0],c*v[1]])
            a=randrange(1,8)
            b=randrange(1,8)
            theta = lambda v : vector([v[0]+a,v[1]+b])
            untheta = lambda v : vector([v[0]-a,v[1]-b])

            trueproperty = choice(["dist_v"])
            falseproperties=[
                "add_assoc",
                "add_comm",
                "dist_s",
            ]

        elif n==1:
            plus = lambda v1,v2 : vector([v1[0]+v2[0], v1[1]+v2[1]])
            r1 = randrange(1,9)
            r2 = randrange(1,9)
            times= lambda c,v : vector([c*v[0]+r1*c*v[1],r2*c*v[1]])
            a=randrange(1,8)
            theta = lambda v : vector([v[0],v[1]+a])
            untheta = lambda v : vector([v[0],v[1]-a])

            trueproperty=choice(["dist_v","dist_s"])
            falseproperties=[
                "mul_assoc",
                "mul_id",
            ]

        elif n==2:            
            plus = lambda v1,v2 : vector([v1[0]+v2[0], v1[1]+v2[1]])
            r2 = randrange(2,4)
            times= lambda c,v : vector([c*v[0],c^(r2)*v[1]])
            a=randrange(1,8)
            b=randrange(2,8)
            theta = lambda v: vector([v[0]+b*v[1],v[1]+a])
            untheta = lambda v : vector([v[0]-b*(v[1]-a),v[1]-a])

            trueproperty=choice(["mul_assoc","mul_id","dist_v"])
            falseproperties=[
                "dist_s",
            ]

        elif n==3:
            r1 = randrange(1,9)
            plus = lambda v1,v2 : vector([v1[0]+v2[0], v1[1]+v2[1]-r1])
            times= lambda c,v : vector([c*v[0],c*v[1]])
            a=randrange(1,5)
            theta = lambda v: vector([v[0],v[1]+a*v[0]^2])
            untheta = lambda v : vector([v[0],v[1]-a*v[0]^2])

            trueproperty=choice(["add_assoc"])
            falseproperties=[
                "dist_v",
                "dist_s",
            ]

        elif n==4:
            r=randrange(3,8)
            plus = lambda v1,v2 : vector([v1[0]+v2[0], v1[1]+v2[1]])
            times= lambda c,v : vector([c*v[0],c*v[1]-r*c+r])            
            a=randrange(1,5)
            b=randrange(1,5)
            theta = lambda v : vector([v[0]+b,v[1]+a*v[0]])
            untheta = lambda v : vector([v[0]-b,v[1]-a*(v[0]-b)])

            trueproperty=choice(["mul_assoc"])
            falseproperties=[
                "dist_v",
                "dist_s",
            ]

        elif n==5:
            r=randrange(1,6)
            plus = lambda v1,v2 : vector([v1[0]+v2[0]+r, v1[1]+v2[1]])
            r1 = randrange(1,6)
            r2 = randrange(1,6)
            times= lambda c,v,: vector([c*v[0]+r1*c*v[1]-r,r2*c*v[1]])
            a=randrange(1,5)
            theta = lambda v: vector([v[0],v[1]+a*v[0]])
            untheta = lambda v : vector([v[0],v[1]-a*v[0]])

            trueproperty=choice(["add_assoc","dist_s"])
            falseproperties=[
                "mul_assoc",
                "mul_id",
                "dist_v",
            ]

        oplus = lambda v1,v2 : theta(plus(untheta(v1),untheta(v2)))
        otimes = lambda c,v : theta(times(c,untheta(v)))

        return {
            "oplus": vectorsimplify(oplus(v1,v2)),
            "otimes": vectorsimplify(otimes(c,v)),
            "trueproperty": {
                trueproperty: verify(trueproperty,oplus,otimes)
            },
            "falseproperties": {f: True for f in falseproperties},
        }