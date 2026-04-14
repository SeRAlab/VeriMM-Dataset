module shift_register (
    input wire clk,
    input wire load,
    input wire [1:0] data_in,
    output reg [1:0] data_out
);
    always @(posedge clk) begin
        if (load) begin
            data_out <= data_in; // Load data on load signal
        end else begin
            data_out <= {data_out[0], 1'b0}; // Shift left
        end
    end
endmodule