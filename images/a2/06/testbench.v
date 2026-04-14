`timescale 1ns/1ps

module binary_subtractor_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire [3:0] difference;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_subtractor dut (
        .a(a),
        .b(b),
        .difference(difference)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Simple Subtraction (10 - 3)", test_num);
            a = 4'd10;
            b = 4'd3;
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Subtract Zero (5 - 0)", test_num);
            a = 4'd5;
            b = 4'd0;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Subtract From Itself (12 - 12)", test_num);
            a = 4'd12;
            b = 4'd12;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Underflow / Wrap-around (2 - 5)", test_num);

            a = 4'd2;
            b = 4'd5;
            #1;

            check_outputs(4'd13);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Maximum Values (15 - 1)", test_num);
            a = 4'd15;
            b = 4'd1;
            #1;

            check_outputs(4'd14);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Boundary Underflow (0 - 1)", test_num);

            a = 4'd0;
            b = 4'd1;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: All Ones (15 - 15)", test_num);
            a = 4'b1111;
            b = 4'b1111;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Subtraction near middle (8 - 4)", test_num);
            a = 4'd8;
            b = 4'd4;
            #1;

            check_outputs(4'd4);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_subtractor Testbench");
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
        input [3:0] expected_difference;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_difference === (expected_difference ^ difference ^ expected_difference)) begin
                $display("PASS");
                $display("  Outputs: difference=%h",
                         difference);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: difference=%h",
                         expected_difference);
                $display("  Got:      difference=%h",
                         difference);
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
