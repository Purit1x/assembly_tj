void func2(int ipt){
    int x2 = ipt+1;
}
void func1(){
    int x1 = 0;
    func2(x1);
}

int main(){
    func1();
    return 0;
}