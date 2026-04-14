module phase_shifter (  
    input [4:0] data_in,  
    input [2:0] phase_shift,  
    output reg [4:0] data_out  
);  
    always @(*) begin  
        case (phase_shift)  
            3'b000: data_out = data_in;  
            3'b001: data_out = {data_in[0], data_in[4:1]};  
            3'b010: data_out = {data_in[1:0], data_in[4:2]};  
            3'b011: data_out = {data_in[2:0], data_in[4:3]};  
            3'b100: data_out = {data_in[3:0], data_in[4]};  
            3'b101: data_out = {data_in[4], data_in[4:1]};  
            3'b110: data_out = {data_in[4:2], data_in[1:0]};  
            3'b111: data_out = {data_in[4:3], data_in[2:0]};  
            default: data_out = 5'b00000;  
        endcase  
    end  
endmodule