module binary_counter
    (
        input rst_n,
        input clk,
        output reg [3:0] counter
    );

    reg [3:0] count;

    always @(posedge clk) 
    begin
        if (!rst_n)
            count <= 4'd0;
        else
            count <= count + 1;
    end
    
    always @(posedge clk)
    begin
        counter <= count;
    end

endmodule