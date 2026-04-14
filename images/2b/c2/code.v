module audio_mux (
    input wire [15:0] A,      // Audio signal A
    input wire [15:0] B,      // Audio signal B
    input wire sel,           // Select signal
    output wire [15:0] Y      // Output audio signal
);
    assign Y = (sel) ? B : A; // If sel is 1, output B, else output A
endmodule