module pipo_shift_register #(parameter N = 8) (
    input clk,
    input load,
    input reset,
    input [N-1:0] data_in,
    output reg [N-1:0] data_out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        data_out <= 0;
    end else if (load) begin
        data_out <= data_in;
    end
end

endmodule