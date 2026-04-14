module ShiftRegister (
    input clk,
    input rst_n,
    input enable,
    input load,
    input [7:0] data_in,
    output reg [7:0] data_out
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 8'b00000000;
        end else if (load) begin
            data_out <= data_in;
        end else if (enable) begin
            data_out <= {1'b0, data_out[7:1]};
        end
    end
endmodule