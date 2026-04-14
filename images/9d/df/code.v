module top_module(
    input [15:0] Addr,
    output [7:0] RData,
    input [7:0] WData,
    input Cmd,
    input RW,
    output Finish,
    input clk,
    input rst_n
    );parameter S_Wait = 0;
    parameter S_Finish = 1;

    reg state = S_Wait;

    reg [7:0]mem[0:15];

    reg fin = 0;
    assign Finish = fin;

    reg [7:0]da;
    assign RData = da;

    always @ (posedge clk) begin
      if (!rst_n) begin
        fin <= 0;
        state <= S_Wait;
      end else begin
        case(state)
        S_Wait:begin
          if(Cmd && (Addr[15:4] == 0)) begin
            state <= S_Finish;
            if(RW == 1) begin 
              mem[Addr[3:0]] <= WData;
              fin <= 1;
            end else begin  
              da <= mem[Addr[3:0]];
              fin <= 1;
            end
          end
        end

        S_Finish:begin
          state <= S_Wait;
          fin <= 0;
        end

        endcase
      end

    end



endmodule