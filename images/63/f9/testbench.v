`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg first;
    reg [6:0] hmesh_last;
    reg next;
    reg sys_clk;
    reg [6:0] vmesh_last;
    wire last;
    wire [31:0] r0;
    wire [31:0] r1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .first(first),
        .hmesh_last(hmesh_last),
        .next(next),
        .sys_clk(sys_clk),
        .vmesh_last(vmesh_last),
        .last(last),
        .r0(r0),
        .r1(r1)
    );

    // Clock generation (10ns period)
    initial begin
        sys_clk = 0;
        forever #5 sys_clk = ~sys_clk;
    end

        task reset_dut;

        begin
            @(posedge sys_clk);
            first = 1;
            next = 0;
            hmesh_last = 0;
            vmesh_last = 0;
            @(posedge sys_clk);
            #1;
            first = 0;
            @(posedge sys_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            hmesh_last = 10;
            vmesh_last = 10;
            @(posedge sys_clk);
            next = 1;
            @(posedge sys_clk);
            next = 0;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            hmesh_last = 2;
            vmesh_last = 5;
            next = 1;
            repeat(3) @(posedge sys_clk);
            next = 0;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            hmesh_last = 1;
            vmesh_last = 1;
            next = 1;

            repeat(3) @(posedge sys_clk);
            next = 0;
            #1;

            check_outputs(1, 1, 1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            reset_dut();
            hmesh_last = 3;
            vmesh_last = 2;
            next = 1;

            repeat(11) @(posedge sys_clk);
            next = 0;
            #1;

            check_outputs(1, 3, 2);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            hmesh_last = 5;
            vmesh_last = 5;
            next = 1;
            @(posedge sys_clk);
            next = 0;
            repeat(5) @(posedge sys_clk);
            #1;

            check_outputs(0, 1, 0);
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
        input expected_last;
        input [31:0] expected_r0;
        input [31:0] expected_r1;
        begin
            if (expected_last === (expected_last ^ last ^ expected_last) &&
                expected_r0 === (expected_r0 ^ r0 ^ expected_r0) &&
                expected_r1 === (expected_r1 ^ r1 ^ expected_r1)) begin
                $display("PASS");
                $display("  Outputs: last=%b, r0=%h, r1=%h",
                         last, r0, r1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: last=%b, r0=%h, r1=%h",
                         expected_last, expected_r0, expected_r1);
                $display("  Got:      last=%b, r0=%h, r1=%h",
                         last, r0, r1);
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
        $dumpvars(0,first, hmesh_last, next, sys_clk, vmesh_last, last, r0, r1);
    end

endmodule
