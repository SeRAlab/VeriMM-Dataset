`timescale 1ns/1ps

module linear_regression_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] x;
    wire [15:0] y_pred;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linear_regression dut (
        .x(x),
        .y_pred(y_pred)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Input", test_num);
            x = 16'd0;

            #1;


            check_outputs(B_VAL);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Input x = 1", test_num);
            x = 16'd1;

            #1;


            check_outputs(M_VAL + B_VAL);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Arbitrary Input (x = 100)", test_num);
            x = 16'd100;

            #1;


            check_outputs(16'd210);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: High Range Input (x = 1000)", test_num);
            x = 16'd1000;

            #1;


            check_outputs(16'd2010);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Overflow Edge Case (Truncation check)", test_num);


            x = 16'd32767;
            #1;

            check_outputs(16'd8);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum Input value", test_num);
            x = 16'hFFFF;


            #1;



            check_outputs(16'd8);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("linear_regression Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [15:0] expected_y_pred;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y_pred === (expected_y_pred ^ y_pred ^ expected_y_pred)) begin
                $display("PASS");
                $display("  Outputs: y_pred=%h",
                         y_pred);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y_pred=%h",
                         expected_y_pred);
                $display("  Got:      y_pred=%h",
                         y_pred);
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
