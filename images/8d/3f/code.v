module top_module(
    input [15:0] a,
    input [15:0] b,
    input clk,
    output [31:0] result
);reg [7:0] reg_file [0:7]; // register file of size 8x16
reg [15:0] a_reg, b_reg, shift_reg; // registers for inputs and shift register
reg [31:0] product_reg; // register for product
reg [3:0] state; // state register for pipeline stages
reg [1:0] count; // count register for booth algorithm
wire [15:0] adder_input; // input to the 16-bit adder

assign adder_input = (state == 0) ? {a_reg[15], a_reg} - (b_reg << 1) :
                    (state == 1) ? {a_reg[15], a_reg} + (b_reg << 1) :
                    (state == 2) ? {a_reg[15], a_reg} : 16'b0;

always @(posedge clk) begin
    if (state == 0) begin // Booth algorithm stage 1
        a_reg <= a;
        b_reg <= b;
        shift_reg <= b;
        count <= 2'b01;
        state <= 1;
    end
    else if (state == 1) begin // Booth algorithm stage 2
        shift_reg <= {shift_reg[14], shift_reg};
        count <= (shift_reg[15:14] == 2'b01 || shift_reg[15:14] == 2'b10) ? 2'b10 : 2'b01;
        state <= 2;
    end
    else if (state == 2) begin // Booth algorithm stage 3
        product_reg <= {16'b0, adder_input} + product_reg;
        state <= 3;
    end
    else begin // Booth algorithm stage 4
        reg_file[count] <= product_reg[15:0];
        product_reg <= {product_reg[31], product_reg[31:16]};
        count <= count + 2'b01;
        state <= (count == 2'b11) ? 0 : 1;
    end
end

assign result = {reg_file[7], reg_file[6], reg_file[5], reg_file[4], reg_file[3], reg_file[2], reg_file[1], reg_file[0]};

endmodule