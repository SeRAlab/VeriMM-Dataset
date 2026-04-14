`timescale 1ns/1ps

module current_ctrl_tb;

    // Testbench signals (combinational circuit)
    reg ctrl;
    wire I;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    current_ctrl dut (
        .ctrl(ctrl),
        .I(I)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: Enable Current (ctrl: 0 -> 1)");

            ctrl = 1'b0;
            #10;

            ctrl = 1'b1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: Disable Current (ctrl: 1 -> 0)");

            ctrl = 1'b1;
            #10;

            ctrl = 1'b0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: Maintain Disabled State (ctrl: 0 -> 0)");

            ctrl = 1'b0;
            #10;

            ctrl = 1'b0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Rapid Toggle Stability");

            ctrl = 1'b0;
            #10;

            ctrl = 1'b1; #5;
            ctrl = 1'b0; #5;
            ctrl = 1'b1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("current_ctrl Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_I;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_I === (expected_I ^ I ^ expected_I)) begin
                $display("PASS");
                $display("  Outputs: I=%b",
                         I);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: I=%b",
                         expected_I);
                $display("  Got:      I=%b",
                         I);
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
