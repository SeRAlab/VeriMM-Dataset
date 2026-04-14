`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    reg [7:0] d;
    reg [31:0] num1;
    reg [31:0] num2;
    reg sub;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .num1(num1),
        .num2(num2),
        .sub(sub),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Addition mode, 'a' is min", test_num);
            a = 8'd10; b = 8'd20; c = 8'd30; d = 8'd40;
            num1 = 32'd100; num2 = 32'd200;
            sub = 1'b0;

            #1;


            check_outputs(32'd310);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Subtraction mode, 'b' is min", test_num);
            a = 8'd50; b = 8'd5; c = 8'd15; d = 8'd25;
            num1 = 32'd1000; num2 = 32'd3;
            sub = 1'b1;

            #1;


            check_outputs(32'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Addition mode, 'c' is min", test_num);
            a = 8'd100; b = 8'd100; c = 8'd2; d = 8'd100;
            num1 = 32'hFFFF_FF00; num2 = 32'd10;
            sub = 1'b0;

            #1;


            check_outputs(32'hFFFF_FF0C);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Subtraction mode, 'd' is min, negative result", test_num);
            a = 8'd255; b = 8'd255; c = 8'd255; d = 8'd10;
            num1 = 32'd0; num2 = 32'd20;
            sub = 1'b1;

            #1;


            check_outputs(32'hFFFF_FFF6);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Addition mode, all min inputs equal", test_num);
            a = 8'd128; b = 8'd128; c = 8'd128; d = 8'd128;
            num1 = 32'd500; num2 = 32'd500;
            sub = 1'b0;

            #1;


            check_outputs(32'd1128);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %03d: Subtraction mode, min value is 0", test_num);
            a = 8'd255; b = 8'd0; c = 8'd127; d = 8'd1;
            num1 = 32'd9999; num2 = 32'd50;
            sub = 1'b1;

            #1;


            check_outputs(32'hFFFF_FFCE);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %03d: Addition mode, 32-bit wrap around", test_num);
            a = 8'd1; b = 8'd2; c = 8'd3; d = 8'd4;
            num1 = 32'hFFFF_FFFF; num2 = 32'd1;
            sub = 1'b0;

            #1;


            check_outputs(32'd1);
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
        input [31:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
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

endmodule
