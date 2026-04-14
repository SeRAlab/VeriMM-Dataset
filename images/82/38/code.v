module reg8 (
    input wire clk,
    input wire rst,
    input wire [7:0] d,
    output reg [7:0] q
);

    always @(posedge clk or posedge rst) begin
        if (rst) 
            q <= 8'b0;
        else 
            q <= d;
    end

endmodule