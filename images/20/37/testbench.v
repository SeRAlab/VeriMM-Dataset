`timescale 1ns/1ps

module adc_simulator_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] analog_input;
    wire [15:0] digital_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_simulator dut (
        .analog_input(analog_input),
        .digital_output(digital_output)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Minimum Input (0x000)", test_num);
        analog_input = 12'h000;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Maximum Input (0xFFF)", test_num);
        analog_input = 12'hFFF;
        #1;

        check_outputs(16'h0FFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Mid-scale Input (0x7FF)", test_num);
        analog_input = 12'h7FF;
        #1;

        check_outputs(16'h07FF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Alternating Bits A (0xAAA)", test_num);
        analog_input = 12'hAAA;
        #1;

        check_outputs(16'h0AAA);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Alternating Bits 5 (0x555)", test_num);
        analog_input = 12'h555;
        #1;

        check_outputs(16'h0555);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Random Pattern (0xA5C)", test_num);
        analog_input = 12'hA5C;
        #1;

        check_outputs(16'h0A5C);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Low Value (0x001)", test_num);
        analog_input = 12'h001;
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: High Value (0xFFE)", test_num);
        analog_input = 12'hFFE;
        #1;

        check_outputs(16'h0FFE);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_simulator Testbench");
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
        input [15:0] expected_digital_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_digital_output === (expected_digital_output ^ digital_output ^ expected_digital_output)) begin
                $display("PASS");
                $display("  Outputs: digital_output=%h",
                         digital_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: digital_output=%h",
                         expected_digital_output);
                $display("  Got:      digital_output=%h",
                         digital_output);
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
