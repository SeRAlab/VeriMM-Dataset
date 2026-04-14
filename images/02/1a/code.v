module ShiftRegister (
    input wire clk,
    input wire reset,
    input wire load,
    input wire [3:0] data_in,
    output reg [3:0] data_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 4'b0000;
        end else if (load) begin
            data_out <= data_in;
        end else begin
            data_out <= {1'b0, data_out[3:1]};
        end
    end
endmodule