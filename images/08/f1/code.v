module qam_transmitter(
    input wire clk,
    input wire [3:0] I,
    input wire [3:0] Q,
    output reg [7:0] QAM_signal
);
    always @(posedge clk) begin
        QAM_signal <= {I, Q}; // Combine I and Q components
    end
endmodule