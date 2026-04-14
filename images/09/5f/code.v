module nvme_controller(  
    input [3:0] command,  
    output reg [7:0] response  
);  
    always @(*) begin  
        case (command)  
            4'b0001: response = 8'h01; // Identify Controller  
            4'b0010: response = 8'h02; // Create I/O Submission Queue  
            4'b0011: response = 8'h03; // Create I/O Completion Queue  
            4'b0100: response = 8'h04; // Get Log Page  
            default: response = 8'h00; // Unknown Command  
        endcase  
    end  
endmodule