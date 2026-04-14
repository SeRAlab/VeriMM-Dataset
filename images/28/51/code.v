module DVFS_Controller(  
    input [2:0] workload,  
    output reg [1:0] voltage  
);  
always @(*) begin  
    case (workload)  
        3'b000: voltage = 2'b00; // Low voltage  
        3'b001: voltage = 2'b00; // Low voltage  
        3'b010: voltage = 2'b01; // Medium-low voltage  
        3'b011: voltage = 2'b01; // Medium-low voltage  
        3'b100: voltage = 2'b10; // Medium-high voltage  
        3'b101: voltage = 2'b10; // Medium-high voltage  
        3'b110: voltage = 2'b11; // High voltage  
        3'b111: voltage = 2'b11; // High voltage  
        default: voltage = 2'b00; // Default to low voltage  
    endcase  
end  
endmodule