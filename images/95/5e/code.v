module binary_counter
    (
        input rst,
        input clk,
        input en,
        output reg [1:0] count
    );

    always @(posedge clk) 
    begin
        if (rst)
            count <= 2'd0;
        else if (en)
            count <= count + 1;
    end

endmodule