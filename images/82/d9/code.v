module shift_register(
    input       [7:0] data ,
    input              clk  ,
    input              load ,
    
    output reg         q
);
    
    reg [7:0] shift_reg;
    
    // 8-bit shift register with parallel load and serial output
    always @(posedge clk) begin
        if (load) begin
            shift_reg <= data;
        end else begin
            shift_reg <= {shift_reg[6:0], 1'b0};
        end
        q <= shift_reg[7];
    end
    
endmodule