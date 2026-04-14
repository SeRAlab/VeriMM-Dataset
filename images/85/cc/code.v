module counter_2bit (
        input clk,
        input rst,
        output reg [1:0] count);

    always @(posedge clk) begin
        if (rst)
            count <= 2'b00;
        else
            count <= count + 1'b1;
    end

endmodule