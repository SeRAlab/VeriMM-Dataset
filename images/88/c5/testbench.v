`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg b;
    reg clk;
    wire o;
    wire state1;
    wire state2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .o(o),
        .state1(state1),
        .state2(state2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 0;
            b = 0;

            @(negedge clk);
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Test Case %0d: a=1, b=0", test_num);
            @(negedge clk);
            a = 1; b = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Test Case %0d: a=1, b=1", test_num);
            @(negedge clk);
            a = 1; b = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Test Case %0d: a=0, b=1", test_num);
            @(negedge clk);
            a = 0; b = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Test Case %0d: a=0, b=0", test_num);
            @(negedge clk);
            a = 0; b = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Test Case %0d: Specification Trace Sequence", test_num);


            @(negedge clk);
            a = 1; b = 0;
            @(posedge clk);


            @(negedge clk);
            a = 1; b = 1;
            @(posedge clk);


            @(negedge clk);
            a = 0; b = 1;
            @(posedge clk);

            #2;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1);
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
        input expected_o;
        input expected_state1;
        input expected_state2;
        begin
            if (expected_o === (expected_o ^ o ^ expected_o) &&
                expected_state1 === (expected_state1 ^ state1 ^ expected_state1) &&
                expected_state2 === (expected_state2 ^ state2 ^ expected_state2)) begin
                $display("PASS");
                $display("  Outputs: o=%b, state1=%b, state2=%b",
                         o, state1, state2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o=%b, state1=%b, state2=%b",
                         expected_o, expected_state1, expected_state2);
                $display("  Got:      o=%b, state1=%b, state2=%b",
                         o, state1, state2);
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
        $dumpvars(0,a, b, clk, o, state1, state2);
    end

endmodule
