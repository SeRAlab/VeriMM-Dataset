module mux_32bit (
    input [31:0] a,       // First 32-bit input
    input [31:0] b,       // Second 32-bit input
    input sel,            // Select signal
    output reg [31:0] out // 32-bit output
);
    always @(*) begin
        if (sel) 
            out = b;      // If sel is 1, output b
        else 
            out = a;      // If sel is 0, output a
    end
endmodule