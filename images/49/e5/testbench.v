`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg i_clk;
    reg [31:0] i_data_in;
    reg [3:0] i_data_in_sel;
    reg [15:0] i_data_out_sel;
    reg [3:0] i_re;
    reg [1:0] i_we;
    wire [127:0] o_data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_clk(i_clk),
        .i_data_in(i_data_in),
        .i_data_in_sel(i_data_in_sel),
        .i_data_out_sel(i_data_out_sel),
        .i_re(i_re),
        .i_we(i_we),
        .o_data_out(o_data_out)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

        task reset_dut;

        integer i;
        begin
            i_we = 2'b00;
            i_re = 4'b0000;
            i_data_in = 32'h0;
            i_data_in_sel = 4'h0;
            i_data_out_sel = 16'h0;
            @(posedge i_clk);

            for (i = 0; i < 16; i = i + 1) begin
                i_we = 2'b01;
                i_data_in_sel = i[3:0];
                i_data_in = 32'h0;
                @(posedge i_clk);
            end
            i_we = 2'b00;
            @(posedge i_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase 001: Basic Write/Read (Reg 5)");


            i_we = 2'b01;
            i_data_in_sel = 4'd5;
            i_data_in = 32'hDEADBEEF;
            @(posedge i_clk);


            i_we = 2'b00;
            i_re = 4'b0001;
            i_data_out_sel = 16'h0005;
            #1;

            #1;


            check_outputs({96'h0, 32'hDEADBEEF});
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase 002: Dual Write (Reg 10 and 11)");



            i_we = 2'b11;
            i_data_in_sel = 4'd10;
            i_data_in = 32'hCAFEBABE;
            @(posedge i_clk);


            i_we = 2'b00;
            i_re = 4'b0011;
            i_data_out_sel = 16'h00BA;
            #1;

            #1;


            check_outputs({64'h0, 32'hCAFEBABE, 32'hCAFEBABE});
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase 003: Read Enable Verification");


            i_we = 2'b01;
            i_data_in_sel = 4'd8;
            i_data_in = 32'h12345678;
            @(posedge i_clk);


            i_we = 2'b00;
            i_re = 4'b1011;
            i_data_out_sel = 16'h0800;
            #1;


            #1;



            check_outputs(128'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase 004: Simultaneous 4-Port Read");


            i_we = 2'b01; i_data_in_sel = 4'd1; i_data_in = 32'h11111111; @(posedge i_clk);
            i_we = 2'b01; i_data_in_sel = 4'd2; i_data_in = 32'h22222222; @(posedge i_clk);
            i_we = 2'b01; i_data_in_sel = 4'd3; i_data_in = 32'h33333333; @(posedge i_clk);
            i_we = 2'b01; i_data_in_sel = 4'd4; i_data_in = 32'h44444444; @(posedge i_clk);


            i_we = 2'b00;
            i_re = 4'b1111;
            i_data_out_sel = 16'h4321;
            #1;

            #1;


            check_outputs({32'h44444444, 32'h33333333, 32'h22222222, 32'h11111111});
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase 005: Wrap-around Write (Reg 15 and 0)");


            i_we = 2'b11;
            i_data_in_sel = 4'd15;
            i_data_in = 32'hA5A5A5A5;
            @(posedge i_clk);


            i_we = 2'b00;
            i_re = 4'b0011;
            i_data_out_sel = 16'h000F;
            #1;

            #1;


            check_outputs({64'h0, 32'hA5A5A5A5, 32'hA5A5A5A5});
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [127:0] expected_o_data_out;
        begin
            if (expected_o_data_out === (expected_o_data_out ^ o_data_out ^ expected_o_data_out)) begin
                $display("PASS");
                $display("  Outputs: o_data_out=%h",
                         o_data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_data_out=%h",
                         expected_o_data_out);
                $display("  Got:      o_data_out=%h",
                         o_data_out);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,i_clk, i_data_in, i_data_in_sel, i_data_out_sel, i_re, i_we, o_data_out);
    end

endmodule
