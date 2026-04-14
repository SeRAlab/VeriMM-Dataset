`timescale 1ns/1ps

module mpc_controller_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] current_state;
    reg [3:0] setpoint;
    wire [3:0] control_action;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mpc_controller dut (
        .current_state(current_state),
        .setpoint(setpoint),
        .control_action(control_action)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Zero error (Setpoint=0, State=0)", test_num);
            setpoint = 4'sd0;
            current_state = 4'sd0;
            #1;

            check_outputs(4'sd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Positive result within limits (Setpoint=5, State=2)", test_num);
            setpoint = 4'sd5;
            current_state = 4'sd2;
            #1;

            check_outputs(4'sd3);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Negative result within limits (Setpoint=-2, State=1)", test_num);
            setpoint = -4'sd2;
            current_state = 4'sd1;
            #1;

            check_outputs(-4'sd3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Positive Saturation (Setpoint=7, State=-8)", test_num);
            setpoint = 4'sd7;
            current_state = -4'sd8;

            #1;


            check_outputs(4'sd7);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Negative Saturation (Setpoint=-8, State=7)", test_num);
            setpoint = -4'sd8;
            current_state = 4'sd7;

            #1;


            check_outputs(-4'sd8);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Boundary saturation test (Setpoint=4, State=-5)", test_num);
            setpoint = 4'sd4;
            current_state = -4'sd5;

            #1;


            check_outputs(4'sd7);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Boundary saturation test (Setpoint=-5, State=4)", test_num);
            setpoint = -4'sd5;
            current_state = 4'sd4;

            #1;


            check_outputs(-4'sd8);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Max error within range positive (Setpoint=0, State=-8)", test_num);
            setpoint = 4'sd0;
            current_state = -4'sd8;

            #1;


            check_outputs(4'sd7);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Matching negative boundaries (Setpoint=-8, State=-8)", test_num);
            setpoint = -4'sd8;
            current_state = -4'sd8;
            #1;

            check_outputs(4'sd0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Small negative difference (Setpoint=-1, State=0)", test_num);
            setpoint = -4'sd1;
            current_state = 4'sd0;
            #1;

            check_outputs(-4'sd1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mpc_controller Testbench");
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
