module top_module(clk, addr, din, dout, enable, rw, access_size, busy);parameter BYTE = 8;
    parameter HALFWORD = 16;
    parameter WORD = 32;
    
    input clk;
    input [31:0] addr;
    input [31:0] din;
    output reg [31:0] dout;  // Change output to reg type
    input enable;
    input rw;
    input [1:0] access_size;
    output reg busy;         // Change busy to reg type
    
    reg [31:0] memory[0:1023];
    
    always @(posedge clk)
    begin
        if(enable)
        begin
            busy <= 1'b1;
            case(access_size)
                2'b00: begin // byte access
                            if(rw) // read operation
                                dout <= {24'b0, memory[addr][7:0]}; // Sign-extend to 32 bits
                            else // write operation
                                memory[addr][7:0] <= din[7:0];
                        end
                2'b01: begin // halfword access
                            if(rw) // read operation
                                dout <= {16'b0, memory[addr][15:0]}; // Sign-extend to 32 bits
                            else // write operation
                                memory[addr][15:0] <= din[15:0];
                        end
                2'b10: begin // word access
                            if(rw) // read operation
                                dout <= memory[addr];
                            else // write operation
                                memory[addr] <= din;
                        end
                default: begin
                            dout <= 32'b0; // Provide a default value for dout
                        end
            endcase
            busy <= 1'b0;
        end
    end
endmodule