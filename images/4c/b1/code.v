module down_counter(
    input clk,
    input reset,
    output reg [2:0] count
);

    always @(negedge clk or posedge reset) begin
        if (reset)
            count <= 3'b111;
        else
            count <= count - 1;
    end
    
endmodule