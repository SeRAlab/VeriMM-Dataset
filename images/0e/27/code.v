module nat_system (
    input [31:0] internal_ip,
    input [15:0] internal_port,
    output reg [31:0] external_ip,
    output reg [15:0] external_port
);
    // NAT mapping
    always @(*) begin
        case ({internal_ip, internal_port})
            {32'hC0A80001, 16'h1F90}: begin // 192.168.0.1:8080
                external_ip = 32'hA1B2C3D4; // 161.178.195.212
                external_port = 16'h1F91; // 8081
            end
            {32'hC0A80002, 16'h1F90}: begin // 192.168.0.2:8080
                external_ip = 32'hA1B2C3D5; // 161.178.195.213
                external_port = 16'h1F92; // 8082
            end
            {32'hC0A80003, 16'h1F90}: begin // 192.168.0.3:8080
                external_ip = 32'hA1B2C3D6; // 161.178.195.214
                external_port = 16'h1F93; // 8083
            end
            default: begin
                external_ip = 32'hFFFFFFFF; // undefined
                external_port = 16'hFFFF; // undefined
            end
        endcase
    end
endmodule