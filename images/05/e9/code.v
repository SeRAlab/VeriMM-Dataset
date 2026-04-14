module round_robin_arbiter (
    input wire clk,
    input wire rst,
    input wire [3:0] req,
    output reg [3:0] grant
);
    reg [1:0] last_grant;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            grant <= 4'b0000;
            last_grant <= 2'b00;
        end else begin
            // Round-robin grant logic
            case (last_grant)
                2'b00: if (req[0]) grant <= 4'b0001; else if (req[1]) grant <= 4'b0010; else if (req[2]) grant <= 4'b0100; else if (req[3]) grant <= 4'b1000;
                2'b01: if (req[1]) grant <= 4'b0010; else if (req[2]) grant <= 4'b0100; else if (req[3]) grant <= 4'b1000; else if (req[0]) grant <= 4'b0001;
                2'b10: if (req[2]) grant <= 4'b0100; else if (req[3]) grant <= 4'b1000; else if (req[0]) grant <= 4'b0001; else if (req[1]) grant <= 4'b0010;
                2'b11: if (req[3]) grant <= 4'b1000; else if (req[0]) grant <= 4'b0001; else if (req[1]) grant <= 4'b0010; else if (req[2]) grant <= 4'b0100;
            endcase
            
            // Update last_grant
            if (grant != 4'b0000)
                last_grant <= last_grant + 1;
        end
    end
endmodule