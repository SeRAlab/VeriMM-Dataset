`timescale 1ns/1ps

module deadbeat_controller_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] current_state;
    reg [3:0] desired_state;
    wire [3:0] control_action;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deadbeat_controller dut (
        .current_state(current_state),
        .desired_state(desired_state),
        .control_action(control_action)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero states (current=0, desired=0)", test_num);
        current_state = 4'd0;
        desired_state = 4'd0;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Positive displacement (current=2, desired=7)", test_num);
        current_state = 4'd2;
        desired_state = 4'd7;
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Negative displacement (current=10, desired=4)", test_num);
        current_state = 4'd10;
        desired_state = 4'd4;
        #1;

        check_outputs(4'd10);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max range positive (current=0, desired=15)", test_num);
        current_state = 4'd0;
        desired_state = 4'd15;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Wrap around negative (current=15, desired=0)", test_num);
        current_state = 4'd15;
        desired_state = 4'd0;
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mid-range equilibrium (current=8, desired=8)", test_num);
        current_state = 4'd8;
        desired_state = 4'd8;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Small negative step (current=1, desired=0)", test_num);
        current_state = 4'd1;
        desired_state = 4'd0;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max values (current=15, desired=15)", test_num);
        current_state = 4'd15;
        desired_state = 4'd15;
        #1;

        check_outputs(4'd0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("deadbeat_controller Testbench");
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
        input [3:0] expected_control_action;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_control_action === (expected_control_action ^ control_action ^ expected_control_action)) begin
                $display("PASS");
                $display("  Outputs: control_action=%h",
                         control_action);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: control_action=%h",
                         expected_control_action);
                $display("  Got:      control_action=%h",
                         control_action);
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
