module up_down_counter
    (
        input rst_n, 
        input clk, 
        input up, 
        input down, 
        output reg [1:0] count
    );

    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n)
            count <= 2'b00;
        else
        begin
            if (up)
                count <= count + 1;
            else if (down)
                count <= count - 1;
        end
    end

endmodule