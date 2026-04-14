module dwt_haar (
    input [7:0] x,
    input clk,
    output reg [7:0] cA,
    output reg [7:0] cD
);
    reg [7:0] data [0:7];
    reg [2:0] count;
    
    always @(posedge clk) begin
        data[count] <= x;  // Store input data
        count <= count + 1;

        if (count == 7) begin // Process after 8 inputs
            cA <= (data[0] + data[1] + data[2] + data[3]) >> 2; // Approximation
            cD <= (data[0] - data[1] + data[2] - data[3]) >> 2; // Detail
            count <= 0; // Reset count for next input
        end
    end
endmodule