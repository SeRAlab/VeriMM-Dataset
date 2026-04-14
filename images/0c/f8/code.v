module shift_register (
    input wire clk,
    input wire load,
    input wire shift,
    input wire [1:0] data_in,
    output reg [1:0] data_out
);

    always @(posedge clk) begin
        if (load) begin
            data_out <= data_in;  // Load data
        end else if (shift) begin
            data_out <= {1'b0, data_out[1:1]};  // Shift right with '0' in MSB
        end
    end

endmodule