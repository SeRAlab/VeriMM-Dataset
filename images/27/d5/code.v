module restoring_divider (  
    input clk,  
    input reset,  
    input [7:0] dividend,  
    input [7:0] divisor,  
    output reg [7:0] quotient,  
    output reg [7:0] remainder,  
    output reg ready  
);  
    reg [7:0] A; // Accumulator  
    reg [7:0] Q; // Quotient register  
    reg [7:0] M; // Divisor  
    reg [3:0] count;  
    reg [1:0] state;  

    localparam IDLE = 2'b00;  
    localparam DIVIDING = 2'b01;  
    localparam DONE = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            quotient <= 0;  
            remainder <= 0;  
            A <= 0;  
            Q <= 0;  
            M <= 0;  
            count <= 0;  
            state <= IDLE;  
            ready <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (divisor != 0) begin  
                        A <= dividend;  
                        M <= divisor;  
                        Q <= 0;  
                        count <= 8;  
                        state <= DIVIDING;  
                        ready <= 0;  
                    end  
                end  
                DIVIDING: begin  
                    A <= {A[6:0], Q[7]}; // Shift left  
                    Q <= {Q[6:0], 1'b0}; // Shift left quotient  
                    A <= A - M; // Subtract divisor  

                    if (A[7] == 1) begin // If A is negative  
                        A <= A + M; // Restore A  
                    end else begin  
                        Q[0] <= 1; // Set last bit of quotient to 1  
                    end  

                    count <= count - 1;  
                    if (count == 0) begin  
                        remainder <= A;  
                        quotient <= Q;  
                        state <= DONE;  
                    end  
                end  
                DONE: begin  
                    ready <= 1;  
                end  
            endcase  
        end  
    end  
endmodule