/**
 * 클래스 상속과 Initializer
 * 부모 클래스의 Initializer를 상속하는 경우
 * 1. 자식 클래스에 Initializer가 없는 경우(별도 초기화가 필요하지 않은 경우)
 * 2. 자식 클래스에서 부모 클래스의 모든 Designated Initializer를 재정의하는 경우 -> Convenience Initializer 상속
 */

class Parent {
    var value1: Int
    
    init(value1: Int) {
        self.value1 = value1
    }
    
    convenience init() {
        self.init(value1: 0)
    }
}

//
// 별도의 초기화가 필요하지 않은 자식 클래스
class Child1: Parent {
    var value2: String = "Hello"
}

// 부모 클래스의 designated, convenience Initializer 모두 상속
let child1_obj1 = Child1()
let child1_obj2 = Child1(value1: 10)

//
// Designated Initializer를 작성한 경우 - 부모 클래스의 Initialzier 상속 안함
class Child2: Parent {
    var value2: String
    
    // designated Initializer
    init(value1: Int, value2: String) {
        self.value2 = value2
        // 부모 클래스의 Designated Initializer만 호출 가능
        super.init(value1: value1)
    }
}

let child2_obj1 = Child2(value1: 1, value2: "2")

//
// 자식 클래스에서 부모 클래스의 모든 Designated Initializer를 재정의 -> Conveninece Initializer 상속
class Child3: Parent {
    var value2: String
    
    // 부모 클래스의 Designated Initializer 재정의
    override init(value1: Int) {
        value2 = "Hello"
        super.init(value1: value1)
    }
}

let child3_obj1 = Child3(value1: 1) // designated initializer로 인스턴스 생성
let cihld3_obj2 = Child3() // 부모 클래스에서 상속받은 convenience initializer로 인스턴스 생성


//
// 초기화가 필요한 프로퍼티가 없고 convenience initialzer만 작성 -> Initializer 상속
class Child4: Parent {
    convenience init(_ value: Int) {
        // Initializer 상속. convenience는 같은 클래스의 Initializer로만 위임 가능
        self.init(value1: value)
    }
}

let child4_obj1 = Child4()
let child4_obj2 = Child4(value1: 0)
let child4_obj3 = Child4(1)

print("Done")


