module NATDevice(  
    input clk,  
    input rst,  
    input mode, // 0 for private to public, 1 for public to private  
    input [31:0] private_ip,  
    input [31:0] public_ip,  
    output reg [31:0] translated_ip  
);  

    reg [31:0] private_to_public_map [0:3];  
    reg [31:0] public_to_private_map [0:3];  

    initial begin  
        // Simple static mapping for demonstration  
        private_to_public_map[0] = 32'hC0A80001; // 192.168.0.1  
        private_to_public_map[1] = 32'hC0A80002; // 192.168.0.2  
        private_to_public_map[2] = 32'hC0A80003; // 192.168.0.3  
        private_to_public_map[3] = 32'hC0A80004; // 192.168.0.4  

        public_to_private_map[0] = 32'hAABBCC01; // 170.187.204.1  
        public_to_private_map[1] = 32'hAABBCC02; // 170.187.204.2  
        public_to_private_map[2] = 32'hAABBCC03; // 170.187.204.3  
        public_to_private_map[3] = 32'hAABBCC04; // 170.187.204.4  
    end  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            translated_ip <= 32'b0;  
        end else begin  
            if (mode == 0) begin  
                // NAT from private to public  
                case (private_ip)  
                    private_to_public_map[0]: translated_ip <= public_to_private_map[0];  
                    private_to_public_map[1]: translated_ip <= public_to_private_map[1];  
                    private_to_public_map[2]: translated_ip <= public_to_private_map[2];  
                    private_to_public_map[3]: translated_ip <= public_to_private_map[3];  
                    default: translated_ip <= 32'b0;  
                endcase  
            end else begin  
                // NAT from public to private  
                case (public_ip)  
                    public_to_private_map[0]: translated_ip <= private_to_public_map[0];  
                    public_to_private_map[1]: translated_ip <= private_to_public_map[1];  
                    public_to_private_map[2]: translated_ip <= private_to_public_map[2];  
                    public_to_private_map[3]: translated_ip <= private_to_public_map[3];  
                    default: translated_ip <= 32'b0;  
                endcase  
            end  
        end  
    end  
endmodule