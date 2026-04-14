module priority_arbiter (
    input  wire [3:0] request,
    output reg  [1:0] grant
);

always @(*) begin
    casez (request)
        4'b1??? : grant = 2'b00; // Grant input 0
        4'b01?? : grant = 2'b01; // Grant input 1
        4'b001? : grant = 2'b10; // Grant input 2
        4'b0001 : grant = 2'b11; // Grant input 3
        default : grant = 2'bxx;  // No grant
    endcase
end

endmodule