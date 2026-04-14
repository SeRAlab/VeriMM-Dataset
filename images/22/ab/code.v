module mersenne_twister(
    input clk,
    input reset,
    output reg [4:0] rand_out,
    output reg valid
);
    reg [4:0] state [0:31];
    reg [4:0] index;
    
    initial begin
        index = 0;
        valid = 0;
        // Initialize the state with some seed values
        state[0] = 5'b00001;
        state[1] = 5'b00010;
        state[2] = 5'b00011;
        state[3] = 5'b00100;
        state[4] = 5'b00101;
        // ... Initialize other states as needed
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            index <= 0;
            valid <= 0;
        end else begin
            index <= (index + 1) % 32; // Circular indexing
            rand_out <= state[index];
            valid <= 1;
        end
    end
endmodule