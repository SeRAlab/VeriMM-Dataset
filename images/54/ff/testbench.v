`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg i_clk;
    reg i_rst;
    reg [15:0] i_signalImag;
    reg [15:0] i_signalReal;
    wire [15:0] o_mag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_signalImag(i_signalImag),
        .i_signalReal(i_signalReal),
        .o_mag(o_mag)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

        task reset_dut;

        begin
            i_rst = 1;
            i_signalReal = 16'd0;
            i_signalImag = 16'd0;
            @(posedge i_clk);
            #1 i_rst = 0;

        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            i_signalReal = 16'sh0000;
            i_signalImag = 16'sh0000;
            @(posedge i_clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            i_signalReal = 16'sd255;
            i_signalImag = 16'sd255;
            @(posedge i_clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            i_signalReal = 16'sd256;
            i_signalImag = 16'sd0;
            @(posedge i_clk);
            #1;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            i_signalReal = 16'sh7FFF;
            i_signalImag = 16'sd0;
            @(posedge i_clk);
            #1;

            #1;


            check_outputs(16'h3FFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            i_signalReal = 16'sd0;
            i_signalImag = -16'sd32768;
            @(posedge i_clk);
            #1;

            #1;


            check_outputs(16'h4000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            i_signalReal = 16'sh7FFF;
            i_signalImag = 16'sh7FFF;
            @(posedge i_clk);
            #1;

            #1;


            check_outputs(16'h7FFE);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            i_signalReal = -16'sd32768;
            i_signalImag = -16'sd32768;
            @(posedge i_clk);
            #1;

            #1;


            check_outputs(16'h8000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            i_signalReal = 16'sd1024;
            i_signalImag = 16'sd2048;
            @(posedge i_clk);
            #1;
            #1;

            check_outputs(16'sd80);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();
            i_signalReal = -16'sd1;
            i_signalImag = -16'sd512;
            @(posedge i_clk);
            #1;
            #1;

            check_outputs(16'h0004);
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
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [15:0] expected_o_mag;
        begin
            if (expected_o_mag === (expected_o_mag ^ o_mag ^ expected_o_mag)) begin
                $display("PASS");
                $display("  Outputs: o_mag=%h",
                         o_mag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_mag=%h",
                         expected_o_mag);
                $display("  Got:      o_mag=%h",
                         o_mag);
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
        $dumpvars(0,i_clk, i_rst, i_signalImag, i_signalReal, o_mag);
    end

endmodule
