`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] data;
    reg trigger;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .trigger(trigger),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        trigger = 0;
        forever #5 trigger = ~trigger;
    end

        task reset_dut;

        begin
            data = 0;
            @(posedge trigger);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;

            data = {12'b0, 4'h0, 8'd25, 8'd15};
            @(posedge trigger);
            #2;
            $display("Testcase %0d: Addition (15 + 25)", test_num);
            #1;

            check_outputs(32'd40);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;

            data = {12'b0, 4'h1, 8'd40, 8'd100};
            @(posedge trigger);
            #2;
            $display("Testcase %0d: Subtraction (100 - 40)", test_num);
            #1;

            check_outputs(32'd60);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;

            data = {12'b0, 4'h2, 8'd9, 8'd12};
            @(posedge trigger);
            #2;
            $display("Testcase %0d: Multiplication (12 * 9)", test_num);
            #1;

            check_outputs(32'd108);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;

            data = {12'b0, 4'h3, 8'd4, 8'd80};
            @(posedge trigger);
            #2;
            $display("Testcase %0d: Division (80 / 4)", test_num);
            #1;

            check_outputs(32'd20);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;

            data = {12'b0, 4'h1, 8'd50, 8'd10};
            @(posedge trigger);
            #2;
            $display("Testcase %0d: Subtraction resulting in negative (-40)", test_num);
            #1;

            check_outputs(32'hFFFFFFD8);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;

            data = {12'b0, 4'h0, 8'hFB, 8'hF6};
            @(posedge trigger);
            #2;
            $display("Testcase %0d: Signed Addition (-10 + -5)", test_num);
            #1;

            check_outputs(32'hFFFFFFF1);
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
        input [31:0] expected_result;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
        $dumpvars(0,data, trigger, result);
    end

endmodule
