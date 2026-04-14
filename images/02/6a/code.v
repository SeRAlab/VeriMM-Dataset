module rnn_cell (
    input wire clk,
    input wire rst,
    input wire [1:0] x,  // 2-bit input
    output reg [1:0] h_out // 2-bit hidden state output
);
    reg [1:0] h; // Internal hidden state

    always @(posedge clk or posedge rst) begin
        if (rst) 
            h <= 2'b00; // Reset hidden state
        else 
            h <= (h + x) & 2'b11; // Update hidden state with input
    end

    always @(posedge clk) begin
        h_out <= h; // Output the current hidden state
    end
endmodule