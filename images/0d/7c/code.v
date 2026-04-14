module pipelined_processor(clk, reset, instruction, reg_write, reg_read1, reg_read2, reg_write_data, reg_read_data1, reg_read_data2);  
    input clk;  
    input reset;  
    input [15:0] instruction;  
    output reg reg_write;  
    output reg [2:0] reg_read1, reg_read2;  
    output reg [7:0] reg_write_data;  
    output reg [7:0] reg_read_data1, reg_read_data2;  
    reg [7:0] reg_file [0:7];  

    reg [4:0] state;  
    parameter IF = 0, ID = 1, EX = 2, MEM = 3, WB = 4;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IF;  
            reg_write <= 0;  
        end else begin  
            case (state)  
                IF: begin  
                    // Fetch instruction from instruction input  
                    reg_read1 <= instruction[10:8];  
                    reg_read2 <= instruction[7:5];  
                    state <= ID;  
                end  
                ID: begin  
                    // Decode instruction  
                    case (instruction[15:11])  
                        5'b00000: begin // ADD  
                            reg_write_data <= reg_file[reg_read1] + reg_file[reg_read2];  
                            reg_write <= 1;  
                        end  
                        5'b00001: begin // SUB  
                            reg_write_data <= reg_file[reg_read1] - reg_file[reg_read2];  
                            reg_write <= 1;  
                        end  
                        5'b00010: begin // AND  
                            reg_write_data <= reg_file[reg_read1] & reg_file[reg_read2];  
                            reg_write <= 1;  
                        end  
                        5'b00011: begin // OR  
                            reg_write_data <= reg_file[reg_read1] | reg_file[reg_read2];  
                            reg_write <= 1;  
                        end  
                        5'b00100: begin // NOT  
                            reg_write_data <= ~reg_file[reg_read1];  
                            reg_write <= 1;  
                        end  
                    endcase  
                    state <= EX;  
                end  
                EX: begin  
                    // Move to memory access or write back  
                    state <= MEM;  
                end  
                MEM: begin  
                    // Write back the result to register  
                    if (reg_write) begin  
                        reg_file[instruction[4:2]] <= reg_write_data;  
                        reg_write <= 0;  
                    end  
                    state <= WB;  
                end  
                WB: begin  
                    // Finish the instruction  
                    state <= IF;  
                end  
            endcase  
        end  
    end  
endmodule