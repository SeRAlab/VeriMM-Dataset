module top_module(output reg [3: 0] Sum, output reg Cout, input [3 : 0] A, B, input Cin);reg [4 : 0] ans;
    always @(*)begin
        ans = A + B + Cin;
        if(ans > 5'b01001)begin
            ans = ans + 5'b00110;
            Cout = 1'b1;
        end
        else Cout = 1'b0;
        Sum = ans;
    end
endmodule