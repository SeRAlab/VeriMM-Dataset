module nat_module (  
    input wire [31:0] private_ip,  
    input wire translate,  
    output reg [31:0] public_ip  
);  
    // Fixed public IP address for translation  
    parameter PUBLIC_IP = 32'hC0A80001; // 192.168.0.1  

    always @(posedge translate) begin  
        if (translate) begin  
            public_ip <= PUBLIC_IP;  
        end else begin  
            public_ip <= 32'b0;  
        end  
    end  
endmodule