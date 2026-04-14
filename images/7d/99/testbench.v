`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in1;
    reg [15:0] in2;
    wire [15:0] a;
    wire [15:0] b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .a(a),
        .b(b)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Division (10 / 2)", test_num);
            in1 = 16'd10;
            in2 = 16'd2;
            #1;

            check_outputs(16'd5, 16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Division with Remainder (17 / 3)", test_num);
            in1 = 16'd17;
            in2 = 16'd3;
            #1;

            check_outputs(16'd5, 16'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Divide Zero by Number (0 / 255)", test_num);
            in1 = 16'd0;
            in2 = 16'd255;
            #1;

            check_outputs(16'd0, 16'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Divide by One (500 / 1)", test_num);
            in1 = 16'd500;
            in2 = 16'd1;
            #1;

            check_outputs(16'd500, 16'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Divide by Self (123 / 123)", test_num);
            in1 = 16'd123;
            in2 = 16'd123;
            #1;

            check_outputs(16'd1, 16'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Divisor Larger than Dividend (5 / 10)", test_num);
            in1 = 16'd5;
            in2 = 16'd10;
            #1;

            check_outputs(16'd0, 16'd5);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Values (65535 / 65535)", test_num);
            in1 = 16'hFFFF;
            in2 = 16'hFFFF;
            #1;

            check_outputs(16'd1, 16'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Dividend by 2 (65535 / 2)", test_num);
            in1 = 16'hFFFF;
            in2 = 16'd2;
            #1;

            check_outputs(16'h7FFF, 16'd1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power of Two (32768 / 256)", test_num);
            in1 = 16'd32768;
            in2 = 16'd256;
            #1;

            check_outputs(16'd128, 16'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Large Numbers (45678 / 123)", test_num);
            in1 = 16'd45678;
            in2 = 16'd123;
            #1;

            check_outputs(16'd371, 16'd45);
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
        input [15:0] expected_a;
        input [15:0] expected_b;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_a === (expected_a ^ a ^ expected_a) &&
                expected_b === (expected_b ^ b ^ expected_b)) begin
                $display("PASS");
                $display("  Outputs: a=%h, b=%h",
                         a, b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a=%h, b=%h",
                         expected_a, expected_b);
                $display("  Got:      a=%h, b=%h",
                         a, b);
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
