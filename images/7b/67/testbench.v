`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg enable;
    reg reset;
    reg taken_i;
    wire prediction_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .enable(enable),
        .reset(reset),
        .taken_i(taken_i),
        .prediction_o(prediction_o)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            taken_i = 0;
            @(posedge clock);
            #1;
            reset = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Initial Reset State", test_num);
            reset_dut();
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transition 0 -> 1 (Taken outcome)", test_num);
            reset_dut();
            enable = 1;
            taken_i = 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transition 1 -> 0 (Not Taken outcome)", test_num);
            reset_dut();

            enable = 1;
            taken_i = 1;
            @(posedge clock);

            taken_i = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Enable logic check (State 0)", test_num);
            reset_dut();
            enable = 0;
            taken_i = 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Enable logic check (State 1)", test_num);
            reset_dut();

            enable = 1;
            taken_i = 1;
            @(posedge clock);

            enable = 0;
            taken_i = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Saturate at State 1", test_num);
            reset_dut();
            enable = 1;
            taken_i = 1;
            @(posedge clock);
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Saturate at State 0", test_num);
            reset_dut();
            enable = 1;
            taken_i = 0;
            @(posedge clock);
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b0);
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
        input expected_prediction_o;
        begin
            if (expected_prediction_o === (expected_prediction_o ^ prediction_o ^ expected_prediction_o)) begin
                $display("PASS");
                $display("  Outputs: prediction_o=%b",
                         prediction_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: prediction_o=%b",
                         expected_prediction_o);
                $display("  Got:      prediction_o=%b",
                         prediction_o);
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
        $dumpvars(0,clock, enable, reset, taken_i, prediction_o);
    end

endmodule
