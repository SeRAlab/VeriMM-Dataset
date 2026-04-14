module mersenne_twister(
    input clk,
    input rst,
    input [31:0] seed,
    output reg [31:0] random_number
);
    reg [31:0] MT[0:623];
    reg [9:0] index;
    
    integer i;

    // Initialization of the state vector
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            MT[0] <= seed;
            for (i = 1; i < 624; i = i + 1) begin
                MT[i] <= {MT[i-1][30:0], 1'b0} ^ (i + 1);
            end
            index <= 0;
        end else begin
            if (index == 0) begin
                for (i = 0; i < 624; i = i + 1) begin
                    MT[i] <= (MT[i] & 32'h80000000) | (MT[(i + 1) % 624] & 32'h7FFFFFFF);
                    MT[i] <= (MT[i] >> 1) ^ (MT[i] % 2 == 0 ? 32'h0 : 32'h9908b0df);
                end
            end
            random_number <= MT[index];
            index <= (index + 1) % 624;
        end
    end
endmodule