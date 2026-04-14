`timescale 1ns/1ps

module mpc_control_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] current_state;
    reg [7:0] desired_state;
    wire [7:0] control_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mpc_control dut (
        .current_state(current_state),
        .desired_state(desired_state),
        .control_signal(control_signal)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Zero error case (desired == current)", test_num);
            current_state = 8'd50;
            desired_state = 8'd50;
            #1;

            check_outputs(8'sd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Positive difference within range", test_num);
            current_state = 8'd20;
            desired_state = 8'd25;
            #1;

            check_outputs(8'sd5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Negative difference within range", test_num);
            current_state = 8'd25;
            desired_state = 8'd20;
            #1;

            check_outputs(8'sd-5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Positive boundary (max value 10)", test_num);
            current_state = 8'd100;
            desired_state = 8'd110;
            #1;

            check_outputs(8'sd10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Negative boundary (min value -10)", test_num);
            current_state = 8'd110;
            desired_state = 8'd100;
            #1;

            check_outputs(8'sd-10);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Positive difference exceeding max limit (> 10)", test_num);
            current_state = 8'd50;
            desired_state = 8'd80;
            #1;

            check_outputs(8'sd10);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Negative difference exceeding min limit (< -10)", test_num);
            current_state = 8'd80;
            desired_state = 8'd50;
            #1;

            check_outputs(8'sd-10);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Edge case with low values", test_num);
            current_state = 8'd2;
            desired_state = 8'd15;
            #1;

            check_outputs(8'sd10);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Edge case with zero desired state", test_num);
            current_state = 8'd5;
            desired_state = 8'd0;
            #1;

            check_outputs(8'sd-5);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: High unsigned value range check", test_num);
            current_state = 8'd250;
            desired_state = 8'd245;
            #1;

            check_outputs(8'sd-5);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mpc_control Testbench");
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
        input [7:0] expected_control_signal;
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
