module NAT (
    input wire clk,
    input wire rst,
    input wire [31:0] internal_ip,
    input wire [31:0] external_ip,
    input wire request,
    output reg [31:0] translated_ip
);

    reg [31:0] nat_table [0:7];  // NAT table with 8 entries
    reg [2:0] state;
    reg [2:0] next_state;
    reg [2:0] entry_index;

    initial begin
        nat_table[0] = 32'hC0A80001;  // 192.168.0.1
        nat_table[1] = 32'hC0A80002;  // 192.168.0.2
        nat_table[2] = 32'hC0A80003;  // 192.168.0.3
        nat_table[3] = 32'hC0A80004;  // 192.168.0.4
        nat_table[4] = 32'hC0A80005;  // 192.168.0.5
        nat_table[5] = 32'hC0A80006;  // 192.168.0.6
        nat_table[6] = 32'hC0A80007;  // 192.168.0.7
        nat_table[7] = 32'hC0A80008;  // 192.168.0.8
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            translated_ip <= 32'b0;
            state <= 3'b000;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case(state)
            3'b000: begin
                if (request) begin
                    entry_index = internal_ip[2:0]; // simple mapping for example
                    next_state = 3'b001;
                end else begin
                    next_state = 3'b000;
                end
            end
            3'b001: begin
                translated_ip = nat_table[entry_index];
                next_state = 3'b000;
            end
            default: begin
                next_state = 3'b000;
            end
        endcase
    end
endmodule