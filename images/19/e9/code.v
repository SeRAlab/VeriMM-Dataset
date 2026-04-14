module pipo_shift_register (
    input wire clk,
    input wire load,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);

always @(posedge clk) begin
    if (load) begin
        data_out <= data_in; // Load data on load signal
    end
end

endmodule