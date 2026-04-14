`timescale 1ns/1ps

module mpc_control_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] current_state;
    wire [4:0] control_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mpc_control dut (
        .current_state(current_state),
        .control_signal(control_signal)
    );
    task testcase001;

        begin
            test_num = 1;
            current_state = 5'd0;
            $display("Test Case %03d: current_state = 0 (Expect decrease: 0)", test_num);
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            current_state = 5'd16;
            $display("Test Case %03d: current_state = 16 (Expect decrease: 0)", test_num);
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            current_state = 5'd17;
            $display("Test Case %03d: current_state = 17 (Expect increase: 31)", test_num);
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            current_state = 5'd31;
            $display("Test Case %03d: current_state = 31 (Expect increase: 31)", test_num);
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            current_state = 5'd10;
            $display("Test Case %03d: current_state = 10 (Expect decrease: 0)", test_num);
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            current_state = 5'd25;
            $display("Test Case %03d: current_state = 25 (Expect increase: 31)", test_num);
            #1;

            check_outputs(5'd31);
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
        input [4:0] expected_control_signal;
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
