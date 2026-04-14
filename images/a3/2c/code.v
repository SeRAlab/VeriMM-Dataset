module top_module(
    input free2,
    input free3,
    input [1:0] tm_count,
    output reg [3:0] fifowp_inc
);always @(*) begin
    if (free3 && (tm_count == 2'b11)) begin
        fifowp_inc = 4'b0011;
    end else if (free2 && (tm_count >= 2'b10)) begin
        fifowp_inc = 4'b0010;
    end else if (tm_count >= 2'b01) begin
        fifowp_inc = 4'b0001;
    end else begin
        fifowp_inc = 4'b0000;
    end
end

endmodule