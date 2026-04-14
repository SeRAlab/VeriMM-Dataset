module pcie_endpoint_controller(  
    input [31:0] data_in,  
    input [2:0] control,  
    output reg [31:0] data_out  
);  
    always @(*) begin  
        case(control)  
            3'b000: data_out = data_in;                       // No encoding  
            3'b001: data_out = data_in ^ 32'hFFFFFFFF;        // Inversion  
            3'b010: data_out = {data_in[15:0], data_in[31:16]}; // Swap bytes  
            3'b011: data_out = {data_in[0], data_in[31:1]};    // Shift left  
            3'b100: data_out = {data_in[30:0], data_in[31]};    // Shift right  
            default: data_out = 32'h00000000;                   // Default case  
        endcase  
    end  
endmodule