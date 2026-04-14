`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg k;
    reg l;
    wire j;
    wire state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .k(k),
        .l(l),
        .j(j),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            k = 0;
            l = 1;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Set Operation (0 -> 1)", test_num);
            reset_dut();
            @(negedge clk);
            k = 1;
            l = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Reset Operation (1 -> 0)", test_num);
            reset_dut();

            @(negedge clk);
            k = 1; l = 0;
            @(posedge clk);
            #2;

            @(negedge clk);
            k = 0; l = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Toggle Operation (0 -> 1)", test_num);
            reset_dut();
            @(negedge clk);
            k = 1;
            l = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Toggle Operation (1 -> 0)", test_num);
            reset_dut();

            @(negedge clk);
            k = 1; l = 0;
            @(posedge clk);
            #2;

            @(negedge clk);
            k = 1; l = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Hold Operation (0 -> 0)", test_num);
            reset_dut();
            @(negedge clk);
            k = 0;
            l = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Hold Operation (1 -> 1)", test_num);
            reset_dut();

            @(negedge clk);
            k = 1; l = 0;
            @(posedge clk);
            #2;

            @(negedge clk);
            k = 0; l = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b1);
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
        input expected_j;
        input expected_state;
        begin
            if (expected_j === (expected_j ^ j ^ expected_j) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: j=%b, state=%b",
                         j, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: j=%b, state=%b",
                         expected_j, expected_state);
                $display("  Got:      j=%b, state=%b",
                         j, state);
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
        $dumpvars(0,clk, k, l, j, state);
    end

endmodule
