module NAT #(parameter PUBLIC_IP = 32'hC0A80001) (  
    input clk,  
    input reset,  
    input [31:0] private_ip,  
    input translate,  
    output reg [31:0] public_ip,  
    output reg valid  
);  
    reg [31:0] ip_mapping [0:15]; // 16 private IP mappings  
    reg [3:0] index;  
    reg found;  
    integer i;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            for (i = 0; i < 16; i = i + 1)  
                ip_mapping[i] <= 32'h0;  
            public_ip <= 32'h0;  
            valid <= 0;  
            index <= 0;  
        end else if (translate) begin  
            found = 0;  
            for (i = 0; i < 16; i = i + 1) begin  
                if (ip_mapping[i] == private_ip) begin  
                    public_ip <= PUBLIC_IP + i;  
                    valid <= 1;  
                    found <= 1;  
                end  
            end  
            if (!found) begin  
                ip_mapping[index] <= private_ip;  
                public_ip <= PUBLIC_IP + index;  
                valid <= 1;  
                index <= (index + 1) % 16;  
            end  
        end  
    end  
endmodule