module binary_counter(
    input clk,
    input reset_n,
    output reg [1:0] count
    );
    
    always @(posedge clk) begin
        if (!reset_n)
            count <= 2'b11;
        else
            count <= count + 1;
    end
endmodule