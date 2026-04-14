module shift_register_16bit (
    input wire clk,
    input wire rst,
    input wire load,
    input wire [15:0] parallel_in,
    output wire serial_out
);

    reg [15:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 16'b0;
        end else if (load) begin
            shift_reg <= parallel_in;
        end else begin
            shift_reg <= {shift_reg[14:0], 1'b0};
        end
    end

    assign serial_out = shift_reg[15];

endmodule