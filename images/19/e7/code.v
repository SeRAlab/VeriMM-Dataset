module round_robin_arbiter (
    input wire clk,
    input wire [3:0] request,
    output reg [3:0] grant
);
    reg [1:0] ptr;

    always @(posedge clk) begin
        case (ptr)
            2'b00: begin
                if (request[0]) begin
                    grant <= 4'b0001;
                    ptr <= 2'b00;
                end else if (request[1]) begin
                    grant <= 4'b0010;
                    ptr <= 2'b01;
                end else if (request[2]) begin
                    grant <= 4'b0100;
                    ptr <= 2'b10;
                end else if (request[3]) begin
                    grant <= 4'b1000;
                    ptr <= 2'b11;
                end
            end
            2'b01: begin
                if (request[1]) begin
                    grant <= 4'b0010;
                    ptr <= 2'b01;
                end else if (request[2]) begin
                    grant <= 4'b0100;
                    ptr <= 2'b10;
                end else if (request[3]) begin
                    grant <= 4'b1000;
                    ptr <= 2'b11;
                end else if (request[0]) begin
                    grant <= 4'b0001;
                    ptr <= 2'b00;
                end
            end
            2'b10: begin
                if (request[2]) begin
                    grant <= 4'b0100;
                    ptr <= 2'b10;
                end else if (request[3]) begin
                    grant <= 4'b1000;
                    ptr <= 2'b11;
                end else if (request[0]) begin
                    grant <= 4'b0001;
                    ptr <= 2'b00;
                end else if (request[1]) begin
                    grant <= 4'b0010;
                    ptr <= 2'b01;
                end
            end
            2'b11: begin
                if (request[3]) begin
                    grant <= 4'b1000;
                    ptr <= 2'b11;
                end else if (request[0]) begin
                    grant <= 4'b0001;
                    ptr <= 2'b00;
                end else if (request[1]) begin
                    grant <= 4'b0010;
                    ptr <= 2'b01;
                end else if (request[2]) begin
                    grant <= 4'b0100;
                    ptr <= 2'b10;
                end
            end
        endcase
    end
endmodule