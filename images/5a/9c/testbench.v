`timescale 1ns/1ps

module adder_subtractor_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg add_sub;
    reg [31:0] b;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_subtractor dut (
        .a(a),
        .add_sub(add_sub),
        .b(b),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Simple Addition (10 + 20)", test_num);
            a = 32'd10;
            b = 32'd20;
            add_sub = 1'b1;
            #1;

            check_outputs(32'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Simple Subtraction (50 - 20)", test_num);
            a = 32'd50;
            b = 32'd20;
            add_sub = 1'b0;
            #1;

            check_outputs(32'd30);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Addition with Overflow Wrap (0xFFFFFFFF + 1)", test_num);
            a = 32'hFFFFFFFF;
            b = 32'h00000001;
            add_sub = 1'b1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Subtraction Resulting in Negative (0 - 1)", test_num);
            a = 32'h00000000;
            b = 32'h00000001;
            add_sub = 1'b0;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Add Identity (0x12345678 + 0)", test_num);
            a = 32'h12345678;
            b = 32'h00000000;
            add_sub = 1'b1;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Subtract to Zero (0xDEADBEEF - 0xDEADBEEF)", test_num);
            a = 32'hDEADBEEF;
            b = 32'hDEADBEEF;
            add_sub = 1'b0;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Large Positive Subtraction (0x80000000 - 0x00000001)", test_num);
            a = 32'h80000000;
            b = 32'h00000001;
            add_sub = 1'b0;
            #1;

            check_outputs(32'h7FFFFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Large Addition (0x7FFFFFFF + 0x7FFFFFFF)", test_num);
            a = 32'h7FFFFFFF;
            b = 32'h7FFFFFFF;
            add_sub = 1'b1;
            #1;

            check_outputs(32'hFFFFFFFE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_subtractor Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
