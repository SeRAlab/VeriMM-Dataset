module binary_counter
    (
        input rst_n, 
        input clk, 
        input enable,
        output reg [3:0] count
    );

    always @(posedge clk or negedge rst_n) 
    begin
        if (!rst_n)
            count <= 4'd0;
        else if (enable)
        begin
            if (count == 4'd15)
                count <= 4'd0;
            else
                count <= count + 1;
        end
    end

endmodule