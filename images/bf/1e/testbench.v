`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in1;
    reg [7:0] in2;
    wire equal;
    wire greater;
    wire less;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .equal(equal),
        .greater(greater),
        .less(less)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Equal zeros", test_num);
            in1 = 8'd0;
            in2 = 8'd0;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Equal positive values", test_num);
            in1 = 8'd55;
            in2 = 8'd55;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Equal negative values (signed interpretation)", test_num);
            in1 = 8'h80;
            in2 = 8'h80;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive in1 > Positive in2", test_num);
            in1 = 8'd100;
            in2 = 8'd50;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive in1 < Positive in2", test_num);
            in1 = 8'd25;
            in2 = 8'd75;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive vs Negative (Signed Comparison)", test_num);
            in1 = 8'd1;
            in2 = 8'hFF;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative vs Positive (Signed Comparison)", test_num);
            in1 = 8'hFE;
            in2 = 8'd10;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative in1 > Negative in2", test_num);
            in1 = 8'hFF;
            in2 = 8'h80;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative in1 < Negative in2", test_num);
            in1 = 8'h81;
            in2 = 8'hFE;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero vs Negative", test_num);
            in1 = 8'd0;
            in2 = 8'h80;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Positive vs Boundary Negative", test_num);
            in1 = 8'h7F;
            in2 = 8'h80;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative vs Zero", test_num);
            in1 = 8'hF0;
            in2 = 8'd0;
            #1;

            check_outputs(0, 0, 1);
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
        testcase011();
        testcase012();
        
        
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
        input expected_equal;
        input expected_greater;
        input expected_less;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_equal === (expected_equal ^ equal ^ expected_equal) &&
                expected_greater === (expected_greater ^ greater ^ expected_greater) &&
                expected_less === (expected_less ^ less ^ expected_less)) begin
                $display("PASS");
                $display("  Outputs: equal=%b, greater=%b, less=%b",
                         equal, greater, less);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: equal=%b, greater=%b, less=%b",
                         expected_equal, expected_greater, expected_less);
                $display("  Got:      equal=%b, greater=%b, less=%b",
                         equal, greater, less);
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
