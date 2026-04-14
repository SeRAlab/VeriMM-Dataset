module sha256_simple (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [511:0] message,
    output reg [255:0] hash,
    output reg ready
);
    reg [511:0] msg_reg;
    reg [255:0] h_reg;
    reg [6:0] stage;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            h_reg <= 256'h6a09e667bb67ae8584caa73b2c6e6c611c5c2021;
            hash <= 0;
            ready <= 0;
            stage <= 0;
        end else if (start) begin
            msg_reg <= message;
            stage <= 1;
            ready <= 0;
        end else if (stage == 1) begin
            // Simplified SHA-256 processing (not full implementation)
            h_reg <= h_reg + msg_reg[255:0]; // Example operation
            stage <= 2;
        end else if (stage == 2) begin
            hash <= h_reg;
            ready <= 1;
            stage <= 0; // Reset stage
        end
    end
endmodule