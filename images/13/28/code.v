module mux_forwarding (
    input wire [3:0] data0,
    input wire [3:0] data1,
    input wire sel,
    output reg [3:0] out
);
    always @(*) begin
        if (sel == 1'b0) begin
            out = data0;
        end else if (sel == 1'b1) begin
            out = data0; // Forwarding data0 when sel is 1
        end else begin
            out = data1; // This case should not happen as sel is only 0 or 1
        end
    end
endmodule