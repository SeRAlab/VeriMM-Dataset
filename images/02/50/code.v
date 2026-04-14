module shift_register (
    input wire [15:0] data_in,
    input wire load,
    input wire shift,
    input wire clk,
    output reg [15:0] data_out
);
    
    always @(posedge clk) begin
        if (load) begin
            data_out <= data_in; // Load data
        end else if (shift) begin
            data_out <= {1'b0, data_out[15:1]}; // Shift right
        end
        // If both load and shift are low, hold the value
    end
endmodule