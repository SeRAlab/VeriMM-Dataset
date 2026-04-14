module ring_counter_3bit(
    input clk, 
    input reset, 
    output reg [2:0] count);

    always @(posedge clk) begin
        if (reset)
            count <= 3'b001;
        else
            count <= {count[1:0], count[2]};
    end
endmodule