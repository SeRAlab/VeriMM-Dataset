module top_module(
    input IN1,
    input IN2,
    output reg Diff,
    output reg B
    );always @(IN1 or IN2)
        begin
            Diff = IN1^ IN2;
            B = ~IN1 & IN2;
        end
    
endmodule