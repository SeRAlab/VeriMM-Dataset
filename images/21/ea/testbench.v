`timescale 1ns/1ps

module floating_point_adder_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    floating_point_adder dut (
        .a(a),
        .b(b),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Simple Addition (1.0 + 1.0)", test_num);
            a = 32'h3f800000;
            b = 32'h3f800000;
            #1;

            check_outputs(32'h40000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Different Exponents (1.0 + 0.5)", test_num);
            a = 32'h3f800000;
            b = 32'h3f000000;
            #1;

            check_outputs(32'h3fc00000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Positive + Negative (-2.0 + 1.0)", test_num);
            a = 32'hc0000000;
            b = 32'h3f800000;
            #1;

            check_outputs(32'hbf800000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Cancellation to Zero (1.0 + -1.0)", test_num);
            a = 32'h3f800000;
            b = 32'hbf800000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Adding Zero (4.5 + 0.0)", test_num);
            a = 32'h40900000;
            b = 32'h00000000;
            #1;

            check_outputs(32'h40900000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Infinity Handling (Inf + 5.0)", test_num);
            a = 32'h7f800000;
            b = 32'h40a00000;
            #1;

            check_outputs(32'h7f800000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: NaN Handling (NaN + 1.0)", test_num);
            a = 32'h7fc00000;
            b = 32'h3f800000;
            #1;

            check_outputs(32'h7fc00000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Infinity Subtraction (Inf - Inf)", test_num);
            a = 32'h7f800000;
            b = 32'hff800000;
            #1;

            check_outputs(32'h7fc00000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Overflow to Infinity", test_num);
            a = 32'h7f7fffff;
            b = 32'h7f7fffff;
            #1;

            check_outputs(32'h7f800000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Both Negative (-1.5 + -2.5)", test_num);
            a = 32'hbfc00000;
            b = 32'hc0200000;
            #1;

            check_outputs(32'hc0800000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("floating_point_adder Testbench");
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
