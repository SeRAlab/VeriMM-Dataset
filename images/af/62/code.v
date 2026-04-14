module johnson_counter_4bit(
    input clk, 
    input reset, 
    output reg [3:0] counter);

    always @(posedge clk) begin
        if (reset)
            counter <= 4'b0000;
        else
            counter <= {~counter[0], counter[3:1]};
    end
endmodule