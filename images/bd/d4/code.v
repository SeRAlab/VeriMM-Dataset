module ShiftRegister (
    input clk,
    input rst_n,
    input load,
    input shift,
    input [7:0] data_in,
    input serial_in,
    output reg [7:0] data_out
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 8'b00000000;
        end else if (load) begin
            data_out <= data_in;
        end else if (shift) begin
            data_out <= {data_out[6:0], serial_in};
        end
    end
endmodule