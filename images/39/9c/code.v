module echo_cancellation (
    input wire clk,
    input wire reset,
    input wire [1:0] in_signal,
    output reg [1:0] out_signal
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out_signal <= 2'b00;
        end else begin
            out_signal <= in_signal;
        end
    end
endmodule