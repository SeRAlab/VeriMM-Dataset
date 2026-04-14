`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a1;
    reg a2;
    reg clk;
    reg r1;
    reg r2;
    wire a0;
    wire r0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a1(a1),
        .a2(a2),
        .clk(clk),
        .r1(r1),
        .r2(r2),
        .a0(a0),
        .r0(r0)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            r1 = 0;
            r2 = 0;
            a1 = 0;
            a2 = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: r1=0, r2=0", test_num);
            reset_dut();
            r1 = 0; r2 = 0;
            a1 = 1; a2 = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: r1=1, r2=0, a1=1", test_num);
            reset_dut();
            r1 = 1; r2 = 0;
            a1 = 1; a2 = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: r1=1, r2=0, a1=0", test_num);
            reset_dut();
            r1 = 1; r2 = 0;
            a1 = 0; a2 = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: r1=0, r2=1, a2=1", test_num);
            reset_dut();
            r1 = 0; r2 = 1;
            a1 = 0; a2 = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: r1=0, r2=1, a2=0", test_num);
            reset_dut();
            r1 = 0; r2 = 1;
            a1 = 1; a2 = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: r1=1, r2=1", test_num);
            reset_dut();
            r1 = 1; r2 = 1;
            a1 = 1; a2 = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
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
        input expected_a0;
        input expected_r0;
        begin
            if (expected_a0 === (expected_a0 ^ a0 ^ expected_a0) &&
                expected_r0 === (expected_r0 ^ r0 ^ expected_r0)) begin
                $display("PASS");
                $display("  Outputs: a0=%b, r0=%b",
                         a0, r0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a0=%b, r0=%b",
                         expected_a0, expected_r0);
                $display("  Got:      a0=%b, r0=%b",
                         a0, r0);
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
        $dumpvars(0,a1, a2, clk, r1, r2, a0, r0);
    end

endmodule
