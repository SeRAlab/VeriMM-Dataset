module sync_counter(
    input clk, // clock input
    input reset, // synchronous reset input
    input enable, // counting enable input
    output reg [3:0] count // 4-bit output
);

always @(posedge clk) begin
    if(reset) begin
        count <= 4'b0; // reset to 0
    end else if(enable) begin
        if(count == 4'b1001) begin
            count <= 4'b0; // reset to 0 after counting to 9
        end else begin
            count <= count + 1; // increment counter
        end
    end
end

endmodule