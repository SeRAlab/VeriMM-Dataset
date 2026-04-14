module binary_counter(
    input clk,
    input reset_n,
    output reg [9:0] count
    );
    
    always @(posedge clk) begin
        if (!reset_n)
            count <= 10'b0000000000;
        else
            count <= count + 2;
    end
endmodule