module shift_register_8bit(
    input [7:0] d, 
    input load, 
    input clk, 
    output q
);
    reg [7:0] shift_reg;
    
    always @(posedge clk) begin
        if (load)
            shift_reg <= d;
        else
            shift_reg <= shift_reg >> 1;
    end
    
    assign q = shift_reg[0];
endmodule