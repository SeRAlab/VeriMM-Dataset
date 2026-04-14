module phase_detector (
    input wire A,
    input wire B,
    output reg [1:0] phase_out
);
    always @(*) begin
        if (A == B) 
            phase_out = 2'b01; // In phase
        else if (A > B) 
            phase_out = 2'b10; // A is leading
        else 
            phase_out = 2'b00; // A is lagging
    end
endmodule