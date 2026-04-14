module top_module(
    input up,
    input en,
    input rst,
    output reg [3:0] out
);always @(posedge en or posedge rst) begin
        if (rst) begin
            out <= 4'b0;
        end else if (en) begin
            if (up) begin
                out <= out + 1;
            end else begin
                out <= out - 1;
            end
        end
    end

endmodule