module top_module(
    input CP,
    input RS,
    output reg [7:0] Q,
    output reg QCC
);parameter PERIOD = 10;

    always @(posedge CP, posedge RS) begin
        if (RS) begin
            Q <= 8'b0;
            QCC <= 1'b0;
        end
        else begin
            if (Q == PERIOD-1) begin
                Q <= 8'b0;
                QCC <= 1'b1;
            end
            else begin
                Q <= Q + 1;
                QCC <= 1'b0;
            end
        end
    end

endmodule