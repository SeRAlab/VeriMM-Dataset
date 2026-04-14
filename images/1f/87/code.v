module round_robin_arbiter(  
    input clk,  
    input rst,  
    input [2:0] request,  
    output reg [2:0] grant  
);  
    reg [1:0] last_granted;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            grant <= 3'b000;  
            last_granted <= 2'b00;  
        end else begin  
            case (last_granted)  
                2'b00: begin  
                    if (request[0]) begin  
                        grant <= 3'b001;  
                        last_granted <= 2'b00;  
                    end else if (request[1]) begin  
                        grant <= 3'b010;  
                        last_granted <= 2'b01;  
                    end else if (request[2]) begin  
                        grant <= 3'b100;  
                        last_granted <= 2'b10;  
                    end else begin  
                        grant <= 3'b000;  
                    end  
                end  
                2'b01: begin  
                    if (request[1]) begin  
                        grant <= 3'b010;  
                        last_granted <= 2'b01;  
                    end else if (request[2]) begin  
                        grant <= 3'b100;  
                        last_granted <= 2'b10;  
                    end else if (request[0]) begin  
                        grant <= 3'b001;  
                        last_granted <= 2'b00;  
                    end else begin  
                        grant <= 3'b000;  
                    end  
                end  
                2'b10: begin  
                    if (request[2]) begin  
                        grant <= 3'b100;  
                        last_granted <= 2'b10;  
                    end else if (request[0]) begin  
                        grant <= 3'b001;  
                        last_granted <= 2'b00;  
                    end else if (request[1]) begin  
                        grant <= 3'b010;  
                        last_granted <= 2'b01;  
                    end else begin  
                        grant <= 3'b000;  
                    end  
                end  
                default: grant <= 3'b000;  
            endcase  
        end  
    end  
endmodule