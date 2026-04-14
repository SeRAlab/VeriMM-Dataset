module top_module(
    input [14:0] address,
    input clock,
    output reg [11:0] q
);always @(posedge clock) begin
    if(address < 15'h0800) begin
        q <= 12'h000;
    end else if(address < 15'h1000) begin
        q <= address[11:0];
    end else begin
        q <= address[14:3];
    end
end

endmodule