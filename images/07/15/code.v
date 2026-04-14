module PIPO_Shift_Register (
    input clk,
    input rst,
    input load,
    input shift,
    input [4:0] data_in,
    output reg [4:0] data_out
);
    reg [4:0] register;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            register <= 5'b00000;
        end else if (load) begin
            register <= data_in;
        end else if (shift) begin
            register <= {1'b0, register[4:1]}; // Shift right
        end
    end

    always @(*) begin
        data_out = register;
    end
endmodule