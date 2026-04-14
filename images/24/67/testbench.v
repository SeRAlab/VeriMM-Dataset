`timescale 1ns/1ps

module deadbeat_controller_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] current_state;
    reg [3:0] desired_state;
    wire [3:0] control_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deadbeat_controller dut (
        .current_state(current_state),
        .desired_state(desired_state),
        .control_signal(control_signal)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Identity transition (0 -> 0)", test_num);
            current_state = 4'd0;
            desired_state = 4'd0;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Simple positive transition (2 -> 5)", test_num);
            current_state = 4'd2;
            desired_state = 4'd5;
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Simple negative transition (10 -> 7)", test_num);
            current_state = 4'd10;
            desired_state = 4'd7;
            #1;

            check_outputs(4'd13);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Transition to maximum (0 -> 15)", test_num);
            current_state = 4'd0;
            desired_state = 4'd15;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Transition from maximum to zero (15 -> 0)", test_num);
            current_state = 4'd15;
            desired_state = 4'd0;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Transition across boundary (14 -> 2)", test_num);
            current_state = 4'd14;
            desired_state = 4'd2;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Middle range transition (8 -> 4)", test_num);
            current_state = 4'd8;
            desired_state = 4'd4;
            #1;

            check_outputs(4'd12);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Small increment (7 -> 8)", test_num);
            current_state = 4'd7;
            desired_state = 4'd8;
            #1;

            check_outputs(4'd1);
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
        input [3:0] expected_control_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_control_signal === (expected_control_signal ^ control_signal ^ expected_control_signal)) begin
                $display("PASS");
                $display("  Outputs: control_signal=%h",
                         control_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: control_signal=%h",
                         expected_control_signal);
                $display("  Got:      control_signal=%h",
                         control_signal);
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
