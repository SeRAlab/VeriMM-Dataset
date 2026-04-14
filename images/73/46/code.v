module counter12bit (
    input wire clk,
    input wire rst,
    input wire en,
    output reg [11:0] count
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            count <= 12'b000000000000;
        else if (en)
            count <= count + 1;
    end

endmodule