`timescale 1ns/1ps

module floating_point_multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    floating_point_multiplier dut (
        .a(a),
        .b(b),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 1.0 * 1.0", test_num);
            a = 32'h3f800000;
            b = 32'h3f800000;
            #1;

            check_outputs(32'h3f800000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 2.0 * 4.0", test_num);
            a = 32'h40000000;
            b = 32'h40800000;
            #1;

            check_outputs(32'h41000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: -2.0 * 4.0 (Sign check)", test_num);
            a = 32'hc0000000;
            b = 32'h40800000;
            #1;

            check_outputs(32'hc1000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 1.5 * 2.5", test_num);
            a = 32'h3fc00000;
            b = 32'h40200000;
            #1;

            check_outputs(32'h40700000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 1.5 * 1.5 (Mantissa normalization check)", test_num);
            a = 32'h3fc00000;
            b = 32'h3fc00000;
            #1;

            check_outputs(32'h40100000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 0.0 * 12.5", test_num);
            a = 32'h00000000;
            b = 32'h41480000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Infinity * 1.0", test_num);
            a = 32'h7f800000;
            b = 32'h3f800000;
            #1;

            check_outputs(32'h7f800000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: -1.0 * -1.0 (Negative * Negative)", test_num);
            a = 32'hbf800000;
            b = 32'hbf800000;
            #1;

            check_outputs(32'h3f800000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 0.5 * 0.5 (Exponent decrement check)", test_num);
            a = 32'h3f000000;
            b = 32'h3f000000;
            #1;

            check_outputs(32'h3e800000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: -10.0 * -2.0", test_num);
            a = 32'hc1200000;
            b = 32'hc0000000;
            #1;

            check_outputs(32'h41a00000);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max Float * 2.0 (Overflow to Infinity)", test_num);
            a = 32'h7f7fffff;
            b = 32'h40000000;
            #1;

            check_outputs(32'h7f800000);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Small product (Underflow check)", test_num);
            a = 32'h00800000;
            b = 32'h3d000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("floating_point_multiplier Testbench");
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
