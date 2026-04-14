module shift_reg_4bit(
    input               clk       ,
    input               reset     ,
    input               serial_in ,
    output reg [3:0]    q         
);

always @(posedge clk) begin
    if (reset)
        q <= 4'd0;
    else
        q <= {q[2:0], serial_in};
end

endmodule