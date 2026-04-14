module nat_module (  
    input clk,  
    input reset,  
    input [31:0] ip_in,  
    input [15:0] port_in,  
    output reg [31:0] ip_out,  
    output reg [15:0] port_out  
);  

    reg [2:0] state;  

    parameter IDLE = 3'b000,  
              MAP_0 = 3'b001,  
              MAP_1 = 3'b010,  
              MAP_2 = 3'b011,  
              MAP_3 = 3'b100,  
              MAP_4 = 3'b101;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            ip_out <= 32'b0;  
            port_out <= 16'b0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (ip_in == 32'hC0A80001 && port_in == 16'h1F90) begin  // 192.168.0.1:8080  
                        state <= MAP_0;  
                    end else if (ip_in == 32'hC0A80002 && port_in == 16'h1F91) begin  // 192.168.0.2:8081  
                        state <= MAP_1;  
                    end else if (ip_in == 32'hC0A80003 && port_in == 16'h1F92) begin  // 192.168.0.3:8082  
                        state <= MAP_2;  
                    end else if (ip_in == 32'hC0A80004 && port_in == 16'h1F93) begin  // 192.168.0.4:8083  
                        state <= MAP_3;  
                    end else if (ip_in == 32'hC0A80005 && port_in == 16'h1F94) begin  // 192.168.0.5:8084  
                        state <= MAP_4;  
                    end  
                end  
                MAP_0: begin  
                    ip_out <= 32'hAC100001; // 172.16.0.1  
                    port_out <= 16'h1F90;  
                    state <= IDLE;  
                end  
                MAP_1: begin  
                    ip_out <= 32'hAC100002; // 172.16.0.2  
                    port_out <= 16'h1F91;  
                    state <= IDLE;  
                end  
                MAP_2: begin  
                    ip_out <= 32'hAC100003; // 172.16.0.3  
                    port_out <= 16'h1F92;  
                    state <= IDLE;  
                end  
                MAP_3: begin  
                    ip_out <= 32'hAC100004; // 172.16.0.4  
                    port_out <= 16'h1F93;  
                    state <= IDLE;  
                end  
                MAP_4: begin  
                    ip_out <= 32'hAC100005; // 172.16.0.5  
                    port_out <= 16'h1F94;  
                    state <= IDLE;  
                end  
                default: state <= IDLE;  
            endcase  
        end  
    end  
endmodule