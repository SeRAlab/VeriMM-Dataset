`timescale 1ns/1ps

module deadbeat_controller_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] ref_signal;
    reg [3:0] system_output;
    wire [3:0] control_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deadbeat_controller dut (
        .ref_signal(ref_signal),
        .system_output(system_output),
        .control_signal(control_signal)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Standard positive difference (10 - 4 = 6)", test_num);
            ref_signal = 4'd10;
            system_output = 4'd4;
            #1;
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero error (5 - 5 = 0)", test_num);
            ref_signal = 4'd5;
            system_output = 4'd5;
            #1;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative difference wrap-around (3 - 8 = -5 -> 11)", test_num);
            ref_signal = 4'd3;
            system_output = 4'd8;
            #1;

            #1;


            check_outputs(4'd11);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum range positive (15 - 0 = 15)", test_num);
            ref_signal = 4'd15;
            system_output = 4'd0;
            #1;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Minimum step negative (0 - 1 = -1 -> 15)", test_num);
            ref_signal = 4'd0;
            system_output = 4'd1;
            #1;

            #1;


            check_outputs(4'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large negative difference (0 - 15 = -15 -> 1)", test_num);
            ref_signal = 4'd0;
            system_output = 4'd15;
            #1;

            #1;


            check_outputs(4'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Midpoint difference (8 - 0 = 8)", test_num);
            ref_signal = 4'd8;
            system_output = 4'd0;
            #1;
            #1;

            check_outputs(4'd8);
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
