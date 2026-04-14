module audio_mixer (
    input [15:0] A,   // Audio signal A
    input [15:0] B,   // Audio signal B
    input sel,        // Selector signal
    output reg [15:0] Y // Output audio signal
);
    always @(*) begin
        if (sel) 
            Y = B; // If sel is 1, output B
        else 
            Y = A; // If sel is 0, output A
    end
endmodule