module vco (
    input wire clk,
    input wire [3:0] control_voltage,
    output reg [7:0] frequency_out
);
    
    always @(posedge clk) begin
        frequency_out <= control_voltage * 10; // Simple scaling for frequency output
    end
endmodule