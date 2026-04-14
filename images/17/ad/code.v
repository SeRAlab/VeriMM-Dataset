module lzw_compressor (
    input clk,
    input rst,
    input [7:0] data_in,
    input valid_in,
    output reg [11:0] code_out,
    output reg valid_out
);
    reg [3:0] state;
    reg [7:0] buffer [0:15];
    reg [3:0] index;
    
    initial begin
        state = 0;
        index = 0;
        valid_out = 0;
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            index <= 0;
            valid_out <= 0;
        end else if (valid_in) begin
            // Simple state machine for LZW compression
            if (state < 16) begin
                buffer[state] <= data_in;
                code_out <= state; // Output the code corresponding to state
                valid_out <= 1;
                state <= state + 1; // Move to next state
            end else begin
                // Reset the state for simplicity after filling
                state <= 0;
                valid_out <= 0;
            end
        end else begin
            valid_out <= 0;
        end
    end
endmodule