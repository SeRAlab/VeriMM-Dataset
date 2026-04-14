module mux2to1 (
    input [3:0] A,
    input [3:0] B,
    input sel,
    output reg [3:0] out
);
    always @(*) begin
        if (sel) 
            out = B;
        else 
            out = A;
    end
endmodule