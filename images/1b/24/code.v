module hazard_detection(  
    input [4:0] rs,  // source register  
    input [4:0] rt,  // target register  
    input [4:0] rd,  // destination register  
    input reg_write,  // write enable signal  
    input [2:0] stage,  // current pipeline stage  
    output reg hazard_detected,  
    output reg [2:0] hazard_stage  
);  

always @(*) begin  
    hazard_detected = 0;  
    hazard_stage = 3'b000;  

    if (reg_write) begin  
        if (rd == rs) begin  
            hazard_detected = 1;  
            hazard_stage = stage;  
        end  
        else if (rd == rt) begin  
            hazard_detected = 1;  
            hazard_stage = stage;  
        end  
    end  
end  
endmodule