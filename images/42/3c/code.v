module top_module(D, Q, C, R, S);input D;
    input C;
    input R;
    input S;
    output reg Q;  // Make Q a reg to hold the value in always block
    
    wire not_R;
    wire not_S;
    wire set;
    wire reset;

    assign not_R = ~R;  // Use bitwise NOT instead of logical NOT
    assign not_S = ~S;  // Use bitwise NOT instead of logical NOT
    assign set = not_R & S;
    assign reset = R & not_S;

    always @(posedge C or posedge reset or posedge set) begin
        if (reset) begin
            Q <= 0;  // Reset the output
        end else if (set) begin
            Q <= 1;  // Set the output
        end else begin
            Q <= D;  // D flip-flop behavior
        end
    end
endmodule