module sequence_detect(    
    input clk,
    input rst_n,
    input seq_in,
    output reg seq_out
);

parameter s0 = 2'b00; // initial state
parameter s1 = 2'b01; // 1
parameter s2 = 2'b10; // 10
parameter s3 = 2'b11; // 101

reg [1:0] state, next_state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        state <= s0;
    else
        state <= next_state;
end

always @(*) begin
    case (state)
        s0: begin
            if (seq_in == 1)
                next_state = s1;
            else
                next_state = s0;
        end
        s1: begin
            if (seq_in == 0)
                next_state = s2;
            else
                next_state = s1;
        end
        s2: begin
            if (seq_in == 1)
                next_state = s3;
            else
                next_state = s0;
        end
        s3: begin
            if (seq_in == 0)
                next_state = s0;
            else
                next_state = s1;
        end
        default: next_state = s0;
    endcase
end

always @(*) begin
    if (~rst_n)
        seq_out = 0;
    else if (state == s3 && seq_in == 0)
        seq_out = 1;
    else
        seq_out = 0;
end

endmodule