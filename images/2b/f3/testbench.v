`timescale 1ns/1ps

module fixed_point_adder_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    wire [31:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fixed_point_adder dut (
        .a(a),
        .b(b),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Positive + Positive (no overflow)", test_num);
            a = 32'h00018000;
            b = 32'h00024000;
            #1;

            check_outputs(32'h0003C000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Negative + Negative (no overflow)", test_num);
            a = 32'hFFFF0000;
            b = 32'hFFFE0000;
            #1;

            check_outputs(32'hFFFD0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mixed Sign Addition", test_num);
            a = 32'hFFFA8000;
            b = 32'h000A0000;
            #1;

            check_outputs(32'h00048000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Fractional Carry-out to Integer", test_num);
            a = 32'h0000C000;
            b = 32'h00008000;
            #1;

            check_outputs(32'h00014000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Identity Addition with Zero", test_num);
            a = 32'h00000000;
            b = 32'hFFFFE000;
            #1;

            check_outputs(32'hFFFFE000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum Positive Overflow (Wraparound)", test_num);
            a = 32'h7FFFFFFF;
            b = 32'h00000001;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum Negative Overflow (Wraparound)", test_num);
            a = 32'h80000000;
            b = 32'hFFFFFFFF;
            #1;

            check_outputs(32'h7FFFFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Large Magnitude Cancellation", test_num);
            a = 32'h80000000;
            b = 32'h7FFF0000;
            #1;

            check_outputs(32'hFFFF0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fixed_point_adder Testbench");
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
        input [31:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
