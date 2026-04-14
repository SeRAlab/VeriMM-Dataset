module top_module(A, B, result);input [3:0] A;
    input [3:0] B;
    output reg [7:0] result; // changed to reg to hold the value in always block

    reg [7:0] temp;
    reg [3:0] i;

    always @* begin
        temp = 0;
        for (i = 0; i < 4; i = i+1) begin
            if (B[i] == 1) begin
                temp = temp + (A << i);
            end
        end
        result = temp; // result can now be assigned
    end
endmodule