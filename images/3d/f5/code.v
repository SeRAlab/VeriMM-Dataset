module chacha20_quarter_round (
    input wire clk,
    input wire rst,
    input wire [31:0] key0,
    input wire [31:0] key1,
    input wire [31:0] key2,
    input wire [31:0] key3,
    input wire [31:0] nonce0,
    input wire [31:0] nonce1,
    output reg [31:0] out0,
    output reg [31:0] out1,
    output reg [31:0] out2,
    output reg [31:0] out3
);
    reg [31:0] state [0:3];

    integer i;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out0 <= 32'b0;
            out1 <= 32'b0;
            out2 <= 32'b0;
            out3 <= 32'b0;
            state[0] <= key0;
            state[1] <= key1;
            state[2] <= key2;
            state[3] <= key3;
        end else begin
            // Load state with nonce
            state[2] <= nonce0;
            state[3] <= nonce1;

            // Perform a quarter round operation
            for (i = 0; i < 4; i = i + 1) begin
                state[0] <= state[0] + state[1];
                state[1] <= {state[1][30:0], state[1][31]} ^ state[0];
                state[2] <= state[2] + state[3];
                state[3] <= {state[3][24:0], state[3][31:25]} ^ state[2];
                state[0] <= state[0] + state[1];
                state[1] <= {state[1][16:0], state[1][31:17]} ^ state[0];
                state[2] <= state[2] + state[3];
                state[3] <= {state[3][8:0], state[3][31:9]} ^ state[2];
            end

            // Output the modified state
            out0 <= state[0];
            out1 <= state[1];
            out2 <= state[2];
            out3 <= state[3];
        end
    end
endmodule