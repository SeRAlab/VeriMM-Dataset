module top_module(
    input clk,
    input reset,
    input [31:0] in,
    output reg [3:0] count
);reg [31:0] prev_in;
    reg [3:0] transition_count;
    
    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 0;
            transition_count <= 0;
        end else begin
            if (in[0] && !prev_in[0]) begin
                transition_count <= transition_count + 1;
            end
            prev_in <= in;
            count <= transition_count;
        end
    end
    
endmodule