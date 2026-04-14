module chacha20 (
    input wire clk,
    input wire rst,
    input wire [31:0] key,
    input wire [31:0] nonce,
    output reg [31:0] output_data
);
    reg [31:0] counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 32'b0;
            output_data <= 32'b0;
        end else begin
            counter <= counter + 1;
            output_data <= key ^ (nonce + counter); // Simplistic transformation for simulation
        end
    end
endmodule