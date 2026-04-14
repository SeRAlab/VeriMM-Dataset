module up_down_counter(
    input clk,
    input reset,
    input up,
    output reg [1:0] count
    );
    
    always @(posedge clk) begin
        if (reset)
            count <= 2'b00;
        else if (up)
            count <= count + 1;
        else
            count <= count - 1;
    end
endmodule