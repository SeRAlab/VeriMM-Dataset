module convolutional_encoder (  
    input wire clk,  
    input wire rst,  
    input wire data_in,  
    output reg [1:0] data_out  
);  
    reg [2:0] state;  
    reg [2:0] next_state;  

    // State Encoding  
    parameter S0 = 3'b000;  
    parameter S1 = 3'b001;  
    parameter S2 = 3'b010;  
    parameter S3 = 3'b011;  
    parameter S4 = 3'b100;  
    parameter S5 = 3'b101;  
    parameter S6 = 3'b110;  
    parameter S7 = 3'b111;  

    // State transitions  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            state <= S0;  
        else  
            state <= next_state;  
    end  

    // Next state logic  
    always @(*) begin  
        case (state)  
            S0: next_state = data_in ? S1 : S0;  
            S1: next_state = data_in ? S2 : S0;  
            S2: next_state = data_in ? S3 : S0;  
            S3: next_state = data_in ? S4 : S0;  
            S4: next_state = data_in ? S5 : S0;  
            S5: next_state = data_in ? S6 : S0;  
            S6: next_state = data_in ? S7 : S0;  
            S7: next_state = data_in ? S0 : S0;  
            default: next_state = S0;  
        endcase  
    end  

    // Output logic (g1 = 7, g2 = 5)  
    always @(*) begin  
        case (state)  
            S0: data_out = 2'b00;  
            S1: data_out = 2'b11;  
            S2: data_out = 2'b10;  
            S3: data_out = 2'b01;  
            S4: data_out = 2'b10;  
            S5: data_out = 2'b11;  
            S6: data_out = 2'b00;  
            S7: data_out = 2'b01;  
            default: data_out = 2'b00;  
        endcase  
    end  
endmodule