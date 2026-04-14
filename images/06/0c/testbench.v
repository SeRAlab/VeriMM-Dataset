`timescale 1ns/1ps

module mpc_controller_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] current_state;
    reg [3:0] gain;
    reg [7:0] setpoint;
    wire [15:0] control_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mpc_controller dut (
        .current_state(current_state),
        .gain(gain),
        .setpoint(setpoint),
        .control_signal(control_signal)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Error (Setpoint == Current State)", test_num);
            current_state = 8'd50;
            setpoint = 8'd50;
            gain = 4'd5;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive Error, Small Gain", test_num);
            current_state = 8'd10;
            setpoint = 8'd20;
            gain = 4'd2;

            #1;


            check_outputs(16'h0014);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative Error, Small Gain", test_num);
            current_state = 8'd20;
            setpoint = 8'd10;
            gain = 4'd3;

            #1;


            check_outputs(16'hFFE2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Gain", test_num);
            current_state = 8'd100;
            setpoint = 8'd200;
            gain = 4'd0;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Positive Range", test_num);
            current_state = 8'd0;
            setpoint = 8'd255;
            gain = 4'd15;

            #1;


            check_outputs(16'h0EF1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Negative Range", test_num);
            current_state = 8'd255;
            setpoint = 8'd0;
            gain = 4'd1;

            #1;


            check_outputs(16'hFF01);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Negative Error with High Gain", test_num);
            current_state = 8'd200;
            setpoint = 8'd50;
            gain = 4'd10;

            #1;


            check_outputs(16'hFA24);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Edge Case - Minimum gain, Minimum Error", test_num);
            current_state = 8'd255;
            setpoint = 8'd254;
            gain = 4'd1;

            #1;


            check_outputs(16'hFFFF);
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
        input [15:0] expected_control_signal;
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
