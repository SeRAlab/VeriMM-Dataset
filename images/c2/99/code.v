module counter (
    input  wire        CLK,
    input  wire        RST,
    input  wire        EN,
    output wire [3:0]  Q
);

    reg [3:0] count;

    always @(posedge CLK) begin
        if (RST) begin
            count <= 4'b0;
        end
        else if (EN) begin
            count <= count + 1;
        end
    end

    assign Q = count;

endmodule