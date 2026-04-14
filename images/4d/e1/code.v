module register_8bit(clk, reset, enable, data, q);

    input clk;
    input reset;
    input enable;
    input [7:0] data;
    output [7:0] q;
    reg [7:0] q;

    always @(posedge clk or posedge reset)
        begin
            if (reset)
                q <= 0;
            else if (enable)
                q <= data;
        end

endmodule