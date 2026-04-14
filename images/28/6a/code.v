module aes_add_round_key (
    input wire clk,
    input wire rst,
    input wire [127:0] state_in,
    input wire [127:0] round_key,
    output reg [127:0] state_out
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state_out <= 128'b0;
        end else begin
            state_out <= state_in ^ round_key; // AddRoundKey operation
        end
    end

endmodule