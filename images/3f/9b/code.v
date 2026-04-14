module fixed_priority_arbiter (
    input wire clk,
    input wire rst,
    input wire [3:0] req,  // 4 request lines
    input wire en,         // enable signal
    output reg [3:0] grant // 4 grant lines
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            grant <= 4'b0000; // Reset all grants
        end else if (en) begin
            grant <= 4'b0000; // Clear all grants initially
            if (req[0]) grant <= 4'b0001; // Grant to Req0
            else if (req[1]) grant <= 4'b0010; // Grant to Req1
            else if (req[2]) grant <= 4'b0100; // Grant to Req2
            else if (req[3]) grant <= 4'b1000; // Grant to Req3
        end
    end
endmodule