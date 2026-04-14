module nat_translation(  
    input [31:0] ip_address,  
    input control, // 0 for internal to external, 1 for external to internal  
    output reg [31:0] translated_ip  
);  
    reg [31:0] internal_ips [0:3]; // Example internal IPs  
    reg [31:0] external_ips [0:3]; // Example external IPs  
    integer i;  

    initial begin  
        // Initialize internal and external IPs  
        internal_ips[0] = 32'hC0A80001; // 192.168.0.1  
        internal_ips[1] = 32'hC0A80002; // 192.168.0.2  
        internal_ips[2] = 32'hC0A80003; // 192.168.0.3  
        internal_ips[3] = 32'hC0A80004; // 192.168.0.4  
        external_ips[0] = 32'hA8C60001; // 168.198.0.1  
        external_ips[1] = 32'hA8C60002; // 168.198.0.2  
        external_ips[2] = 32'hA8C60003; // 168.198.0.3  
        external_ips[3] = 32'hA8C60004; // 168.198.0.4  
    end  

    always @(*) begin  
        translated_ip = 32'h00000000; // Default output  
        if (control == 0) begin // Internal to External  
            for (i = 0; i < 4; i = i + 1) begin  
                if (ip_address == internal_ips[i]) begin  
                    translated_ip = external_ips[i];  
                end  
            end  
        end else begin // External to Internal  
            for (i = 0; i < 4; i = i + 1) begin  
                if (ip_address == external_ips[i]) begin  
                    translated_ip = internal_ips[i];  
                end  
            end  
        end  
    end  
endmodule