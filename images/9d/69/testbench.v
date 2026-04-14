`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] afl;
    reg clk;
    wire [15:0] fx_int;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .afl(afl),
        .clk(clk),
        .fx_int(fx_int)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            afl = 32'h0000_0000;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            afl = 32'h0000_0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            afl = 32'h3f80_0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            afl = 32'hbf80_0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hffff);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            afl = 32'h42c8_0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            afl = 32'hc3fa_0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hfe0c);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            afl = 32'h46ff_fe00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h7fff);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            afl = 32'hc700_0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            afl = 32'h412e_6666;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd10);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            afl = 32'h3f00_0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();
            afl = 32'h4180_0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0010);
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
        input [15:0] expected_fx_int;
        begin
            if (expected_fx_int === (expected_fx_int ^ fx_int ^ expected_fx_int)) begin
                $display("PASS");
                $display("  Outputs: fx_int=%h",
                         fx_int);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fx_int=%h",
                         expected_fx_int);
                $display("  Got:      fx_int=%h",
                         fx_int);
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
        $dumpvars(0,afl, clk, fx_int);
    end

endmodule
