module down_counter(
    input clk,
    input reset_n,
    output reg [3:0] count
    );
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            count <= 4'b1111;
        else
            count <= count - 1;
    end
endmodule