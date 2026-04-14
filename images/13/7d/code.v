module fixed_priority_arbiter(
    input wire clk,
    input wire reset,
    input wire [3:0] REQ,
    output reg [3:0] GRANT
);

    reg [3:0] current_grant;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            GRANT <= 4'b0000;
            current_grant <= 4'b0000;
        end else begin
            current_grant = 4'b0000; // Default
            if (REQ[3]) begin
                current_grant = 4'b1000; // Grant REQ[3]
            end else if (REQ[2]) begin
                current_grant = 4'b0100; // Grant REQ[2]
            end else if (REQ[1]) begin
                current_grant = 4'b0010; // Grant REQ[1]
            end else if (REQ[0]) begin
                current_grant = 4'b0001; // Grant REQ[0]
            end
            GRANT <= current_grant;
        end
    end
endmodule