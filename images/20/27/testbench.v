`timescale 1ns/1ps

module DAC_24bit_tb;

    // Testbench signals (combinational circuit)
    reg control;
    reg [23:0] data_in;
    wire [23:0] voltage_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC_24bit dut (
        .control(control),
        .data_in(data_in),
        .voltage_out(voltage_out)
    );
    task testcase001;

        begin
            $display("Testcase 001: Control is 0, Input is Maximum (Output should be 0)");
            test_num = 1;
            control = 1'b0;
            data_in = 24'hFFFFFF;
            #1;

            check_outputs(24'h000000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Control is 1, Input is 0 (Output should be 0)");
            test_num = 2;
            control = 1'b1;
            data_in = 24'h000000;
            #1;

            check_outputs(24'h000000);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Control is 1, Input is Maximum (Output should be Maximum)");
            test_num = 3;
            control = 1'b1;
            data_in = 24'hFFFFFF;
            #1;

            check_outputs(24'hFFFFFF);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Control is 1, Input is Mid-range (Output should match Input)");
            test_num = 4;
            control = 1'b1;
            data_in = 24'h800000;
            #1;

            check_outputs(24'h800000);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Control is 0, Input is Arbitrary (Output should be 0)");
            test_num = 5;
            control = 1'b0;
            data_in = 24'hA5A5A5;
            #1;

            check_outputs(24'h000000);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Control is 1, Input is Smallest Step (Output should be 1)");
            test_num = 6;
            control = 1'b1;
            data_in = 24'h000001;
            #1;

            check_outputs(24'h000001);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Control is 1, Input is Random Pattern (Output should match Input)");
            test_num = 7;
            control = 1'b1;
            data_in = 24'h123456;
            #1;

            check_outputs(24'h123456);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DAC_24bit Testbench");
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
        input [23:0] expected_voltage_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_voltage_out === (expected_voltage_out ^ voltage_out ^ expected_voltage_out)) begin
                $display("PASS");
                $display("  Outputs: voltage_out=%h",
                         voltage_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: voltage_out=%h",
                         expected_voltage_out);
                $display("  Got:      voltage_out=%h",
                         voltage_out);
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
