module decoder_4to16 (
    input wire [3:0] A,    // 4-bit input
    input wire enable,      // enable signal
    output reg [15:0] Y     // 16-bit output
);

    always @(*) begin
        if (enable) begin
            Y = 16'b0000000000000000; // deactivate all outputs
            Y[A] = 1'b1;               // activate the correct output
        end else begin
            Y = 16'b0000000000000000; // deactivate all outputs
        end
    end
endmodule