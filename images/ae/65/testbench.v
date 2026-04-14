`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] a;
    reg [1:0] iterations;
    reg ready;
    wire [15:0] result;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .iterations(iterations),
        .ready(ready),
        .result(result),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        ready = 0;
        forever #5 ready = ~ready;
    end

        task reset_dut;

        begin
            a <= 16'h0;
            iterations <= 2'b0;


            repeat(2) @(posedge ready);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase %0d: a = 100, iterations = 3", test_num);
            a <= 16'd100;
            iterations <= 2'd3;


            wait(valid === 1'b1);

            @(posedge ready);
            #1;

            check_outputs(16'd10, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase %0d: a = 144, iterations = 3", test_num);
            a <= 16'd144;
            iterations <= 2'd3;

            wait(valid === 1'b1);
            @(posedge ready);
            #1;

            check_outputs(16'd12, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase %0d: a = 0, iterations = 3", test_num);
            a <= 16'd0;
            iterations <= 2'd3;

            wait(valid === 1'b1);
            @(posedge ready);
            #1;

            check_outputs(16'd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase %0d: a = 1, iterations = 3", test_num);
            a <= 16'd1;
            iterations <= 2'd3;

            wait(valid === 1'b1);
            @(posedge ready);
            #1;

            check_outputs(16'd1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase %0d: a = 65025, iterations = 3", test_num);
            a <= 16'd65025;
            iterations <= 2'd3;

            wait(valid === 1'b1);
            @(posedge ready);


            #1;



            check_outputs(16'd255, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase %0d: a = 200, iterations = 3", test_num);
            a <= 16'd200;
            iterations <= 2'd3;

            wait(valid === 1'b1);
            @(posedge ready);

            #1;


            check_outputs(16'd14, 1'b1);
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
        input [15:0] expected_result;
        input expected_valid;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: result=%h, valid=%b",
                         result, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, valid=%b",
                         expected_result, expected_valid);
                $display("  Got:      result=%h, valid=%b",
                         result, valid);
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
        $dumpvars(0,a, iterations, ready, result, valid);
    end

endmodule
