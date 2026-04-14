module phase_detector (
    input clk,
    input A,
    input B,
    output reg [1:0] out
);
    
    always @(posedge clk) begin
        if (A == B) begin
            out <= 2'b00; // In-phase
        end else if (A > B) begin
            out <= 2'b01; // A leading
        end else begin
            out <= 2'b10; // A lagging
        end
    end
endmodule