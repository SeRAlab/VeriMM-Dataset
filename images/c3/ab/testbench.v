`timescale 1ns/1ps

module calculator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire overflow;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    calculator dut (
        .a(a),
        .b(b),
        .overflow(overflow),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Positive addition (no overflow)", test_num);
            a = 8'd10; b = 8'd20;
            #1;

            check_outputs(1'b0, 8'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Negative addition (no overflow)", test_num);
            a = -8'd10; b = -8'd20;
            #1;

            check_outputs(1'b0, -8'd30);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mixed sign addition (result positive)", test_num);
            a = 8'd50; b = -8'd20;
            #1;

            check_outputs(1'b0, 8'd30);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mixed sign addition (result negative)", test_num);
            a = -8'd50; b = 8'd20;
            #1;

            check_outputs(1'b0, -8'd30);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero values", test_num);
            a = 8'd0; b = 8'd0;
            #1;

            check_outputs(1'b0, 8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum positive boundary (no overflow)", test_num);
            a = 8'd127; b = 8'd0;
            #1;

            check_outputs(1'b0, 8'd127);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum negative boundary (no overflow)", test_num);
            a = -8'd128; b = 8'd0;
            #1;

            check_outputs(1'b0, -8'd128);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Positive overflow (127 + 1)", test_num);
            a = 8'd127; b = 8'd1;
            #1;

            check_outputs(1'b1, 8'h80);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Positive overflow (Large positive + Large positive)", test_num);
            a = 8'd70; b = 8'd70;
            #1;

            check_outputs(1'b1, 8'd140);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Negative overflow (-128 + -1)", test_num);
            a = -8'd128; b = -8'd1;
            #1;

            check_outputs(1'b1, 8'h7F);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Negative overflow (Large negative + Large negative)", test_num);
            a = -8'd100; b = -8'd50;
            #1;

            check_outputs(1'b1, 8'd106);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Opposing extremes (no overflow)", test_num);
            a = 8'd127; b = -8'd128;
            #1;

            check_outputs(1'b0, 8'hFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("calculator Testbench");
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
        input expected_overflow;
        input [7:0] expected_result;
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
