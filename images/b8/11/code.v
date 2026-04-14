module counter_4bit(
    input clk,
    input en,
    input reset,
    output reg [3:0] count
    );

    always @ (posedge clk)
    begin
        if (reset)
            count <= 4'b0000;
        else if (en)
            count <= count + 1;
    end
endmodule