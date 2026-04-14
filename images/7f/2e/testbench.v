`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ld;
    reg rst;
    reg [1:0] wIn;
    wire [2:0] wOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ld(ld),
        .rst(rst),
        .wIn(wIn),
        .wOut(wOut)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ld = 0;
            wIn = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            @(posedge clk);
            #1 #1;
 check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            wIn = 2'd0;
            ld = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(3'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            wIn = 2'd1;
            ld = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(3'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            wIn = 2'd2;
            ld = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(3'd4);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            wIn = 2'd3;
            ld = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(3'd6);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            wIn = 2'd2;
            ld = 1;
            @(posedge clk);

            #1 ld = 0;
            wIn = 2'd3;
            @(posedge clk);

            #1 #1;
 check_outputs(3'd4);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();

            wIn = 2'd3;
            ld = 1;
            rst = 1;
            @(posedge clk);

            #1 #1;
 check_outputs(3'd0);
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
        input [2:0] expected_wOut;
        begin
            if (expected_wOut === (expected_wOut ^ wOut ^ expected_wOut)) begin
                $display("PASS");
                $display("  Outputs: wOut=%h",
                         wOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: wOut=%h",
                         expected_wOut);
                $display("  Got:      wOut=%h",
                         wOut);
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
        $dumpvars(0,clk, ld, rst, wIn, wOut);
    end

endmodule
