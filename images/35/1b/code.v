module pipo_shift_register (
    input wire clk,
    input wire rst,
    input wire load,
    input wire shift,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] register;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            register <= 8'b0;
            data_out <= 8'b0;
        end else if (load) begin
            register <= data_in;
        end else if (shift) begin
            data_out <= register;
        end
    end
endmodule