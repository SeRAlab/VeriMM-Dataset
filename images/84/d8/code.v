module top_module(
    input CLK,
    input RST,
    input UP,
    output reg [3:0] OUT
);always @(posedge CLK) begin
        if (RST) begin
            OUT <= 4'b0000;
        end else begin
            if (UP) begin
                if (OUT == 4'b1111) begin
                    OUT <= 4'b0000;
                end else begin
                    OUT <= OUT + 1;
                end
            end else begin
                if (OUT == 4'b0000) begin
                    OUT <= 4'b1111;
                end else begin
                    OUT <= OUT - 1;
                end
            end
        end
    end

endmodule