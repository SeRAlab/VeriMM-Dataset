module sync_counter(
    input rst,
    input clk,
    output reg [3:0] count
);

    always @(posedge clk) begin
        if(rst) begin
            count <= 4'b0;
        end else begin
            count <= count + 1;
        end
    end

endmodule