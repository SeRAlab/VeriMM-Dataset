`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg mode;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .mode(mode),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        mode = 0;
        forever #5 mode = ~mode;
    end

        task reset_dut;

        begin
            a = 0;
            b = 0;

            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 4'd5;
            b = 4'd3;
            wait(mode == 0);
            #2;
            $display("Test %0d: Addition 5 + 3", test_num);
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 4'd10;
            b = 4'd4;
            wait(mode == 1);
            #2;
            $display("Test %0d: Subtraction 10 - 4", test_num);
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 4'd12;
            b = 4'd6;
            wait(mode == 0);
            #2;
            $display("Test %0d: Addition Overflow 12 + 6", test_num);
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 4'd3;
            b = 4'd5;
            wait(mode == 1);
            #2;
            $display("Test %0d: Subtraction Negative 3 - 5", test_num);
            #1;

            check_outputs(4'd14);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 4'd15;
            b = 4'd15;
            wait(mode == 0);
            #2;
            $display("Test %0d: Addition Max Values 15 + 15", test_num);
            #1;

            check_outputs(4'd14);

            wait(mode == 1);
            #2;
            $display("Test %0d: Subtraction Max Values 15 - 15", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 4'd0;
            b = 4'd0;
            wait(mode == 0);
            #2;
            $display("Test %0d: Zeros Addition", test_num);
            #1;

            check_outputs(4'd0);
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
        input [3:0] expected_result;
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
        $dumpvars(0,a, b, mode, result);
    end

endmodule
