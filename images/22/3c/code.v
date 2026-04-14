module shift_register (
    input clk,
    input reset,
    input load,
    input shift,
    input [1:0] data_in,
    output reg [1:0] data_out
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 2'b00; // Reset the register
        end else if (load) begin
            data_out <= data_in; // Load new data
        end else if (shift) begin
            data_out <= {data_out[0], 1'b0}; // Shift left
        end
    end
endmodule