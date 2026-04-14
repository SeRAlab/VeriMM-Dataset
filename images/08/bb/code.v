module NAT (
    input wire clk,
    input wire reset,
    input wire [31:0] internal_ip,
    output reg [31:0] external_ip,
    output reg [7:0] translation_count
);
    reg [31:0] fixed_external_ip = 32'hC0A80001; // Example external IP: 192.168.0.1
    reg [3:0] delay_counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            external_ip <= 32'b0;
            translation_count <= 8'b0;
            delay_counter <= 4'b0;
        end else begin
            if (delay_counter < 4'b1111) begin
                delay_counter <= delay_counter + 1;
            end else begin
                external_ip <= fixed_external_ip; // Assign fixed external IP
                translation_count <= translation_count + 1;
                delay_counter <= 4'b0; // Reset delay counter
            end
        end
    end
endmodule