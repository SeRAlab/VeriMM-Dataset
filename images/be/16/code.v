module top_module(
    input wire a, 
    input wire b,
    output reg out,
    input wire [7:0] in_hi,
    input wire [7:0] in_lo,
    output wire [15:0] out_concat
);// XOR gate using only XOR gates and inverters
    wire xor1 = ~(a & b);
    wire xor2 = ~(a & xor1);
    wire xor3 = ~(b & xor1);
    wire xor4 = ~(xor2 & xor3);
    
    // 16-bit concatenation module
    assign out_concat = {in_hi, in_lo};
    
    // Functional module
    always @(*) begin
        if(out_concat >= 8'h80) begin
            out = xor4;
        end else begin
            out = out_concat[7:0];
        end
    end
    
endmodule