module top_module(
    input CLK,
    input RST,
    output [3:0] Q
);reg [3:0] count;

always @(posedge CLK) begin
    if(RST) begin
        count <= 0;
    end
    else begin
        count <= count + 1;
    end
end

assign Q = count;

endmodule