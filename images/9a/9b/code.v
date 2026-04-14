module johnson_counter(
    input               clk,
    input               rst,
    
    output reg [2:0]    johnson_code
);

always@(posedge clk or posedge rst) begin
    if (rst)
        johnson_code <= 3'b000;
    else
        johnson_code <= {~johnson_code[0], johnson_code[2:1]};
end

endmodule