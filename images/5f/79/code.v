module ring_counter (
    input clk,
    input clr,
    output reg [4:0] ring);

    always @(posedge clk) begin
        if (clr) begin
            ring <= 5'b00001;
        end else begin
            ring <= {ring[3:0], ring[4]};
        end
    end
endmodule