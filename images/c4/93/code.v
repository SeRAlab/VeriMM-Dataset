module mux_2to1 (
    input wire D0, 
    input wire D1,
    input wire S,
    input wire RST,
    input wire CLK,
    output reg Y
);

    always @(posedge CLK) begin
        if (RST) begin
            Y <= 0;
        end else begin
            if (S) begin
                Y <= D1;
            end else begin
                Y <= D0;
            end
        end
    end

endmodule