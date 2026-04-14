`timescale 1ns/1ps

module vco_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] control_voltage;
    wire [3:0] frequency_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    vco dut (
        .control_voltage(control_voltage),
        .frequency_output(frequency_output)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: control_voltage = 0", test_num);
            control_voltage = 4'd0;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: control_voltage = 1", test_num);
            control_voltage = 4'd1;
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: control_voltage = 2", test_num);
            control_voltage = 4'd2;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: control_voltage = 4", test_num);
            control_voltage = 4'd4;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: control_voltage = 7", test_num);
            control_voltage = 4'd7;
            #1;

            check_outputs(4'd14);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: control_voltage = 8 (Overflow Case)", test_num);
            control_voltage = 4'd8;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: control_voltage = 12 (Overflow Case)", test_num);
            control_voltage = 4'd12;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: control_voltage = 15 (Max value, Overflow Case)", test_num);
            control_voltage = 4'd15;
            #1;

            check_outputs(4'd14);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("vco Testbench");
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
        input [3:0] expected_frequency_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_frequency_output === (expected_frequency_output ^ frequency_output ^ expected_frequency_output)) begin
                $display("PASS");
                $display("  Outputs: frequency_output=%h",
                         frequency_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frequency_output=%h",
                         expected_frequency_output);
                $display("  Got:      frequency_output=%h",
                         frequency_output);
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
