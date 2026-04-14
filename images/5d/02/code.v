module top_module(
    input EN,
    output reg Q0,
    output reg Q1,
    output reg Q2,
    output reg Q3
);reg [3:0] count;

    always @(posedge EN) begin
        if (EN) begin
            count <= 4'b0000;
            Q0 <= count[0];
            Q1 <= count[1] ^ count[0];
            Q2 <= count[2] ^ count[1];
            Q3 <= count[3] ^ count[2];
        end else begin
            Q0 <= Q0;
            Q1 <= Q1;
            Q2 <= Q2;
            Q3 <= Q3;
        end
    end

endmodule