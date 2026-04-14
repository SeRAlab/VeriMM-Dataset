module rising_edge_counter(
    input clk,
    input reset,
    input in,
    output reg [7:0] count);

    reg in_d;
    
    always @(posedge clk) begin
        if (reset)
            count <= 8'b0;
        else begin
            in_d <= in;
            if (~in_d & in)
                count <= count + 1;
        end
    end
endmodule