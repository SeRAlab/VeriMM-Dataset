module shift_register_4bit(
    input           clk,
    input           rst,
    input           load,
    input           en,
    input   [3:0]   data_in,
    output reg      data_out
);
    reg [3:0] shift_reg;
    
    always @(posedge clk or posedge rst) begin
        if (rst)
            shift_reg <= 4'b0;
        else if (load)
            shift_reg <= data_in;
        else if (en)
            shift_reg <= {1'b0, shift_reg[3:1]};
    end
    
    always @(*) begin
        data_out = shift_reg[0];
    end

endmodule