`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in_signal;
    reg reset;
    wire out_signal;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_signal(in_signal),
        .reset(reset),
        .out_signal(out_signal),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in_signal = 0;
            @(posedge clk);
            #1 reset = 0;

        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transition S0 -> S1 -> S2", test_num);
            reset_dut();

            in_signal = 1;
            @(posedge clk);
            #1;
            in_signal = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 2'd2);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transition S0 -> S1 -> S2 -> S3", test_num);
            reset_dut();

            in_signal = 1; @(posedge clk); #1;
            in_signal = 0; @(posedge clk); #1;
            in_signal = 1; @(posedge clk); #1;

            #1;


            check_outputs(1'b1, 2'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Alternation S3 -> S2", test_num);
            reset_dut();

            in_signal = 1; @(posedge clk); #1;
            in_signal = 0; @(posedge clk); #1;
            in_signal = 1; @(posedge clk); #1;
            in_signal = 1; @(posedge clk); #1;

            #1;


            check_outputs(1'b1, 2'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Return to S0 from S3", test_num);
            reset_dut();

            in_signal = 1; @(posedge clk); #1;
            in_signal = 0; @(posedge clk); #1;
            in_signal = 1; @(posedge clk); #1;
            in_signal = 0; @(posedge clk); #1;

            #1;


            check_outputs(1'b0, 2'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Stay in S1 (in=1)", test_num);
            reset_dut();

            in_signal = 1;
            @(posedge clk); #1;
            @(posedge clk); #1;

            #1;


            check_outputs(1'b0, 2'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Stay in S2 (in=0)", test_num);
            reset_dut();

            in_signal = 1; @(posedge clk); #1;
            in_signal = 0; @(posedge clk); #1;
            in_signal = 0; @(posedge clk); #1;

            #1;


            check_outputs(1'b1, 2'd2);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multiple S2-S3 alternations", test_num);
            reset_dut();

            in_signal = 1; @(posedge clk); #1;
            in_signal = 0; @(posedge clk); #1;
            in_signal = 1; @(posedge clk); #1;
            in_signal = 1; @(posedge clk); #1;
            in_signal = 1; @(posedge clk); #1;

            #1;


            check_outputs(1'b1, 2'd3);
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
        input expected_out_signal;
        input [1:0] expected_state;
        begin
            if (expected_out_signal === (expected_out_signal ^ out_signal ^ expected_out_signal) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: out_signal=%b, state=%h",
                         out_signal, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_signal=%b, state=%h",
                         expected_out_signal, expected_state);
                $display("  Got:      out_signal=%b, state=%h",
                         out_signal, state);
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
        $dumpvars(0,clk, in_signal, reset, out_signal, state);
    end

endmodule
