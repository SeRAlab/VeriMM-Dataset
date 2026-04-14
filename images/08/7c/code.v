module rnn_inference (
    input clk,
    input rst,
    input [3:0] x, // input vector
    output reg [3:0] h // hidden state
);
    reg [3:0] W[3:0]; // weight matrix
    reg [3:0] temp_h;

    // Initialize weight matrix
    initial begin
        W[0] = 4'b0001; 
        W[1] = 4'b0010; 
        W[2] = 4'b0100; 
        W[3] = 4'b1000; 
    end

    // Sequential logic to process input and update hidden state
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            h <= 4'b0000; // reset hidden state
        end else begin
            temp_h = (W[0] & {4{x[0]}}) | (W[1] & {4{x[1]}}) | (W[2] & {4{x[2]}}) | (W[3] & {4{x[3]}});
            h <= h + temp_h; // update hidden state
        end
    end
endmodule