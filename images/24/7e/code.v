module nat_device (
    input wire [31:0] private_ip,
    input wire [31:0] public_ip,
    input wire control,
    output reg [31:0] output_ip
);
    always @(*) begin
        if (control) begin
            output_ip = public_ip; // Map to public IP
        end else begin
            output_ip = private_ip; // Output private IP
        end
    end
endmodule