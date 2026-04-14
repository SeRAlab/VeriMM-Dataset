module top_module(
    input clk,
    input reset,      // Synchronous active-high reset
    input up_down,    // Control signal to increment or decrement
    output [3:0] q);reg [3:0] count;
    
    always @(posedge clk) begin
        if (reset) begin
            count <= 4'b0;
        end else if (up_down) begin
            count <= (count == 4'b1111) ? 4'b0 : count + 1;
        end else begin
            count <= (count == 4'b0000) ? 4'b1111 : count - 1;
        end
    end
    
    assign q = count;
    
endmodule