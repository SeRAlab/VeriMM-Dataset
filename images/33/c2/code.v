module pcie_request_handler (
    input [4:0] request,
    input [4:0] address,
    output reg [4:0] response
);

always @(*) begin
    if (address < 5'b10000) begin
        response = request;
    end else begin
        response = 5'b00000;
    end
end

endmodule