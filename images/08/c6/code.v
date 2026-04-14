module NAT_Translator (  
    input wire clk,  
    input wire reset,  
    input wire enable,  
    input wire [31:0] private_ip,  
    output reg [31:0] public_ip  
);  

    reg [31:0] mapping_table [0:7]; // Simple mapping table  
    initial begin  
        // Example mappings  
        mapping_table[0] = 32'hC0A80001; // 192.168.0.1  
        mapping_table[1] = 32'hC0A80002; // 192.168.0.2  
        mapping_table[2] = 32'hC0A80003; // 192.168.0.3  
        mapping_table[3] = 32'hC0A80004; // 192.168.0.4  
        mapping_table[4] = 32'hC0A80005; // 192.168.0.5  
        mapping_table[5] = 32'hC0A80006; // 192.168.0.6  
        mapping_table[6] = 32'hC0A80007; // 192.168.0.7  
        mapping_table[7] = 32'hC0A80008; // 192.168.0.8  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            public_ip <= 32'b0;  
        end else if (enable) begin  
            case (private_ip)  
                32'hC0A80001: public_ip <= 32'h1A2B3C4D; // Example public IP  
                32'hC0A80002: public_ip <= 32'h1A2B3C4E;  
                32'hC0A80003: public_ip <= 32'h1A2B3C4F;  
                32'hC0A80004: public_ip <= 32'h1A2B3C50;  
                32'hC0A80005: public_ip <= 32'h1A2B3C51;  
                32'hC0A80006: public_ip <= 32'h1A2B3C52;  
                32'hC0A80007: public_ip <= 32'h1A2B3C53;  
                32'hC0A80008: public_ip <= 32'h1A2B3C54;  
                default: public_ip <= private_ip; // No translation  
            endcase  
        end  
    end  
endmodule