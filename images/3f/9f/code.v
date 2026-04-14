module phase_shifter (
    input wire clk,
    input wire reset,
    input wire [2:0] control,
    output reg [2:0] phase
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            phase <= 3'b000; // Reset phase to 0
        end else begin
            phase <= control; // Update phase based on control input
        end
    end
endmodule