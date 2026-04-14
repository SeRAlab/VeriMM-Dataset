`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire overflow;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .overflow(overflow),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Zero multiplication", test_num);
            a = 8'd0; b = 8'd0;
            #1;

            check_outputs(1'b0, 16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Identity multiplication (Positive)", test_num);
            a = 8'd25; b = 8'd1;
            #1;

            check_outputs(1'b0, 16'd25);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Positive * Positive", test_num);
            a = 8'd10; b = 8'd12;
            #1;

            check_outputs(1'b0, 16'd120);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Positive * Negative", test_num);
            a = 8'd5; b = -8'd10;
            #1;

            check_outputs(1'b0, -16'd50);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Negative * Negative (Small)", test_num);
            a = -8'd4; b = -8'd3;
            #1;

            check_outputs(1'b0, 16'd12);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Maximum Positive * Maximum Positive", test_num);
            a = 8'd127; b = 8'd127;
            #1;

            check_outputs(1'b0, 16'd16129);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Maximum Negative * Maximum Positive", test_num);
            a = -8'd128; b = 8'd127;
            #1;

            check_outputs(1'b0, -16'd16256);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Maximum Negative * Maximum Negative", test_num);
            a = -8'd128; b = -8'd128;
            #1;

            check_outputs(1'b0, 16's16384);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %03d: Multiplied by -1", test_num);
            a = 8'd50; b = -8'd1;
            #1;

            check_outputs(1'b0, -16'd50);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %03d: Large Negative * small Positive", test_num);
            a = -8'd128; b = 8'd2;
            #1;

            check_outputs(1'b0, -16'd256);
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input expected_overflow;
        input [15:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: overflow=%b, result=%h",
                         overflow, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: overflow=%b, result=%h",
                         expected_overflow, expected_result);
                $display("  Got:      overflow=%b, result=%h",
                         overflow, result);
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

endmodule
