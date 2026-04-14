`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg req_0;
    reg req_1;
    reg rst;
    wire gnt_0;
    wire gnt_1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .req_0(req_0),
        .req_1(req_1),
        .rst(rst),
        .gnt_0(gnt_0),
        .gnt_1(gnt_1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            req_0 = 0;
            req_1 = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial Reset State");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single Request Client 0");
            test_num = 2;
            reset_dut();
            req_0 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Single Request Client 1");
            test_num = 3;
            reset_dut();
            req_1 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Simultaneous Requests (req_0 and req_1)");
            test_num = 4;
            reset_dut();
            req_0 = 1;
            req_1 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Mutual Exclusion - Client 0 holds while Client 1 requests");
            test_num = 5;
            reset_dut();
            req_0 = 1;
            @(posedge clk);
            #1;
            req_1 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Handover from Client 0 to Client 1");
            test_num = 6;
            reset_dut();
            req_0 = 1;
            @(posedge clk);
            #1;
            req_0 = 0;
            req_1 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
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
        input expected_gnt_0;
        input expected_gnt_1;
        begin
            if (expected_gnt_0 === (expected_gnt_0 ^ gnt_0 ^ expected_gnt_0) &&
                expected_gnt_1 === (expected_gnt_1 ^ gnt_1 ^ expected_gnt_1)) begin
                $display("PASS");
                $display("  Outputs: gnt_0=%b, gnt_1=%b",
                         gnt_0, gnt_1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gnt_0=%b, gnt_1=%b",
                         expected_gnt_0, expected_gnt_1);
                $display("  Got:      gnt_0=%b, gnt_1=%b",
                         gnt_0, gnt_1);
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
        $dumpvars(0,clk, req_0, req_1, rst, gnt_0, gnt_1);
    end

endmodule
