module aes_key_schedule (
    input wire clk,
    input wire rst,
    input wire [127:0] key,
    output reg [127:0] round_key
);
    reg [127:0] rcon;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            round_key <= 128'b0;
            rcon <= 128'h01; // Initial round constant
        end else begin
            round_key <= key ^ rcon; // Example operation for key schedule
            rcon <= {rcon[126:0], 1'b0}; // Shift left for next round constant
        end
    end
endmodule