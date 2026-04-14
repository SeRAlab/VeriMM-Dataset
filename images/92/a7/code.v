module shift_register_8bit(
    input clk, 
    input rst, 
    input load, 
    input [7:0] data, 
    output reg serial_out);

    reg [7:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 8'b00000000;
            serial_out <= 0;
        end else if (load) begin
            shift_reg <= data;
        end else begin
            serial_out <= shift_reg[7];
            shift_reg <= {shift_reg[6:0], 1'b0};
        end
    end
endmodule