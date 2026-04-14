module NAT (
    input [31:0] internal_ip,
    input [31:0] external_ip,
    input control,
    output reg [31:0] output_ip
);
    always @(*) begin
        if (control) 
            output_ip = external_ip;
        else 
            output_ip = internal_ip;
    end
endmodule