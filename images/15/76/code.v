module voltage_regulator_fsm(  
    input clk,  
    input rst,  
    input [4:0] input_voltage,  
    output reg [4:0] output_voltage  
);  
    reg [2:0] state;  
    parameter LOW = 3'b000, BELOW_NOMINAL = 3'b001, NOMINAL = 3'b010, ABOVE_NOMINAL = 3'b011, HIGH = 3'b100;  
  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            state <= NOMINAL;  
        else begin  
            case (state)  
                LOW: begin  
                    if (input_voltage < 5'b00001)  
                        state <= LOW;  
                    else  
                        state <= BELOW_NOMINAL;  
                end  
                BELOW_NOMINAL: begin  
                    if (input_voltage < 5'b00010)  
                        state <= BELOW_NOMINAL;  
                    else  
                        state <= NOMINAL;  
                end  
                NOMINAL: begin  
                    if (input_voltage > 5'b00010)  
                        state <= ABOVE_NOMINAL;  
                    else if (input_voltage < 5'b00001)  
                        state <= BELOW_NOMINAL;  
                end  
                ABOVE_NOMINAL: begin  
                    if (input_voltage > 5'b00011)  
                        state <= HIGH;  
                    else  
                        state <= NOMINAL;  
                end  
                HIGH: begin  
                    if (input_voltage > 5'b00011)  
                        state <= HIGH;  
                    else  
                        state <= ABOVE_NOMINAL;  
                end  
            endcase  
        end  
    end  
  
    always @(*) begin  
        case (state)  
            LOW: output_voltage = 5'b00000;  
            BELOW_NOMINAL: output_voltage = 5'b00001;  
            NOMINAL: output_voltage = 5'b00010;  
            ABOVE_NOMINAL: output_voltage = 5'b00011;  
            HIGH: output_voltage = 5'b00100;  
            default: output_voltage = 5'b00010;  
        endcase  
    end  
endmodule