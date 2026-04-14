module pipo_shift_register (
    input clk,
    input load,
    input reset,
    input [4:0] data_in,
    output reg [4:0] data_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 5'b00000;
        end else if (load) begin
            data_out <= data_in;
        end
    end
endmodule