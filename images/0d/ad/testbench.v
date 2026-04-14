`timescale 1ns/1ps

module float_add_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    wire [31:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    float_add dut (
        .a(a),
        .b(b),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simple addition (1.0 + 1.0 = 2.0)", test_num);
            a = 32'h3F800000;
            b = 32'h3F800000;
            #1;

            check_outputs(32'h40000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Different exponents (1.5 + 2.5 = 4.0)", test_num);
            a = 32'h3FC00000;
            b = 32'h40200000;
            #1;

            check_outputs(32'h40800000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Positive and Negative (10.0 + -5.0 = 5.0)", test_num);
            a = 32'h41200000;
            b = 32'hC0A00000;
            #1;

            check_outputs(32'h40A00000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Adding zero (0.0 + 12.5 = 12.5)", test_num);
            a = 32'h00000000;
            b = 32'h41480000;
            #1;

            check_outputs(32'h41480000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Two negative numbers (-1.0 + -1.0 = -2.0)", test_num);
            a = 32'hBF800000;
            b = 32'hBF800000;
            #1;

            check_outputs(32'hC0000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Cancellation/Renormalization (1.25 + -1.0 = 0.25)", test_num);
            a = 32'h3FA00000;
            b = 32'hBF800000;
            #1;

            check_outputs(32'h3E800000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Subtraction to Zero (5.5 + -5.5 = 0.0)", test_num);
            a = 32'h40B00000;
            b = 32'hC0B00000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Addition requiring right shift (1.625 + 1.5 = 3.125)", test_num);
            a = 32'h3FD00000;
            b = 32'h3FC00000;
            #1;

            check_outputs(32'h40480000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("float_add Testbench");
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
