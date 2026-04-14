`timescale 1ns/1ps

module linear_regulator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] fb_voltage;
    reg [7:0] ref_voltage;
    wire [1:0] control_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linear_regulator dut (
        .fb_voltage(fb_voltage),
        .ref_voltage(ref_voltage),
        .control_signal(control_signal)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Increase Output (fb_voltage < ref_voltage)");
            ref_voltage = 8'd150;
            fb_voltage = 8'd100;

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Decrease Output (fb_voltage > ref_voltage)");
            ref_voltage = 8'd100;
            fb_voltage = 8'd150;

            #1;


            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Maintain Output (fb_voltage == ref_voltage)");
            ref_voltage = 8'd128;
            fb_voltage = 8'd128;

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Boundary Condition - Zero Voltages");
            ref_voltage = 8'd0;
            fb_voltage = 8'd0;

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Boundary Condition - Max Voltages");
            ref_voltage = 8'd255;
            fb_voltage = 8'd255;

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Maximum Increase Required");
            ref_voltage = 8'd255;
            fb_voltage = 8'd0;

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Maximum Decrease Required");
            ref_voltage = 8'd0;
            fb_voltage = 8'd255;

            #1;


            check_outputs(2'b10);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase 008: Slight Increase (Off by 1)");
            ref_voltage = 8'd128;
            fb_voltage = 8'd127;

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase 009: Slight Decrease (Off by 1)");
            ref_voltage = 8'd128;
            fb_voltage = 8'd129;

            #1;


            check_outputs(2'b10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("linear_regulator Testbench");
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
        input [1:0] expected_control_signal;
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
