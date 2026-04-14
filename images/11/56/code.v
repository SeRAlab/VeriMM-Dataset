module shift_register (
    input clk,
    input rst,
    input load,
    input serial_in,
    input [7:0] parallel_in,
    output reg [7:0] shift_reg
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 8'b0;
        end else if (load) begin
            shift_reg <= parallel_in;
        end else begin
            shift_reg <= {shift_reg[6:0], serial_in};
        end
    end
endmodule