module nat(
    input wire [31:0] internal_ip, // Internal IP address
    input wire [31:0] external_ip, // External IP address
    input wire select, // Select signal
    output reg [31:0] translated_ip // Output: Translated IP address
);
    always @(*) begin
        if (select) begin
            translated_ip = internal_ip; // Output internal IP
        end else begin
            translated_ip = external_ip; // Output external IP
        end
    end
endmodule