module lfsr(
    input wire clk,
    input wire reset,
    input wire load,
    input wire [31:0] seed,
    output reg [31:0] lfsr_out
);
    wire feedback;
    
    assign feedback = lfsr_out[31] ^ lfsr_out[21] ^ lfsr_out[20] ^ lfsr_out[0];
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr_out <= 32'b0;
        end else if (load) begin
            lfsr_out <= seed;
        end else begin
            lfsr_out <= {lfsr_out[30:0], feedback};
        end
    end
endmodule