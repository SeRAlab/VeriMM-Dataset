module shift_register (
    input wire clk,
    input wire load,
    input wire shift_enable,
    input wire [15:0] parallel_in,
    output reg [15:0] parallel_out
);
    
    always @(posedge clk) begin
        if (load) begin
            parallel_out <= parallel_in; // Load new value
        end else if (shift_enable) begin
            parallel_out <= {1'b0, parallel_out[15:1]}; // Shift right
        end
    end
endmodule