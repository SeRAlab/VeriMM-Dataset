module nat (
    input [4:0] private_ip,
    input nat_type,
    output reg [4:0] public_ip
);

reg [4:0] dynamic_base = 5'b00000;

always @(*) begin
    if (nat_type == 1'b0) begin // static NAT
        public_ip = 5'b11111;
    end else begin // dynamic NAT
        public_ip = dynamic_base;
        dynamic_base = dynamic_base + 1;
    end
end

endmodule