module prbs_generator (
    input clk,
    input rst,
    input en,
    output reg [9:0] prbs);

    always @(posedge clk) begin
        if (rst) begin
            prbs <= 10'b0000000001;
        end else if (en) begin
            prbs <= {prbs[8:0], prbs[9] ^ prbs[6]};
        end
    end
endmodule