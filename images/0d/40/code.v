module nat_module(  
    input wire clk,  
    input wire [31:0] private_ip,  
    input wire [31:0] public_ip,  
    input wire ctrl,  
    output reg [31:0] translated_ip  
);  
  
always @(posedge clk) begin  
    if (ctrl) begin  
        translated_ip <= public_ip;  
    end else begin  
        translated_ip <= private_ip;  
    end  
end  
endmodule