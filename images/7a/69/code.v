module top_module(
    input A,
    input B,
    input C,
    input D,
    input quarter,
    output reg productA,
    output reg productB,
    output reg productC,
    output reg productD
);// Define the four states
    parameter idle = 2'b00;
    parameter A_pressed = 2'b01;
    parameter B_pressed = 2'b10;
    parameter C_pressed = 2'b11;
    
    // Define the state register and initialize it to idle
    reg [1:0] state = idle;
    
    always @(*) begin
        case (state)
            idle: begin
                if (A) begin
                    state <= A_pressed;
                end else if (B) begin
                    state <= B_pressed;
                end else if (C) begin
                    state <= C_pressed;
                end else if (D) begin
                    state <= idle;
                end
            end
            A_pressed: begin
                if (quarter) begin
                    productA <= 1;
                    state <= idle;
                end
            end
            B_pressed: begin
                if (quarter) begin
                    productB <= 1;
                    state <= idle;
                end
            end
            C_pressed: begin
                if (quarter) begin
                    productC <= 1;
                    state <= idle;
                end
            end
        endcase
    end
endmodule