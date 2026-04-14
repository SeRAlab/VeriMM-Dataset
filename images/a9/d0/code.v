module ring_counter(
    input               clk,
    input               rst,
    
    output reg [2:0]    ring_code
);

always@(posedge clk or posedge rst) begin
    if (rst)
        ring_code <= 3'b001;
    else begin
        case (ring_code)
            3'b001: ring_code <= 3'b010;
            3'b010: ring_code <= 3'b100;
            3'b100: ring_code <= 3'b001;
            default: ring_code <= 3'b001;
        endcase
    end
end

endmodule