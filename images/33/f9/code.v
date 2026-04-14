module deadbeat_controller (
    input clk,
    input [1:0] in_signal,
    output reg [1:0] out_signal
);
    reg [1:0] state;
    
    always @(posedge clk) begin
        state <= in_signal;
        out_signal <= state; // Deadbeat control just assigns input to output
    end
endmodule