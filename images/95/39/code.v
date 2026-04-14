module counter3bit (
    input clk,
    input rst,
    output reg [2:0] count
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            count <= 3'b000;
        else
            count <= count + 1;
    end

endmodule