`timescale 1ns/1ps

module DAC_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] digital_input;
    reg enable;
    wire [7:0] analog_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC dut (
        .digital_input(digital_input),
        .enable(enable),
        .analog_output(analog_output)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: DAC Disabled (enable=0) with zero input", test_num);
        enable = 0;
        digital_input = 8'h00;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: DAC Disabled (enable=0) with max input", test_num);
        enable = 0;
        digital_input = 8'hFF;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: DAC Enabled (enable=1) with zero input", test_num);
        enable = 1;
        digital_input = 8'h00;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: DAC Enabled (enable=1) with max input (0xFF)", test_num);
        enable = 1;
        digital_input = 8'hFF;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: DAC Enabled (enable=1) with pattern 0xAA", test_num);
        enable = 1;
        digital_input = 8'hAA;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: DAC Enabled (enable=1) with pattern 0x55", test_num);
        enable = 1;
        digital_input = 8'h55;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Transition from Disabled to Enabled with active input", test_num);
        digital_input = 8'hC3;
        enable = 0;
        #5;
        enable = 1;
        #1;

        check_outputs(8'hC3);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Transition from Enabled to Disabled with active input", test_num);
        digital_input = 8'h3C;
        enable = 1;
        #5;
        enable = 0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: DAC Enabled with midrange value 0x80", test_num);
        enable = 1;
        digital_input = 8'h80;
        #1;

        check_outputs(8'h80);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DAC Testbench");
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
        input [7:0] expected_analog_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_analog_output === (expected_analog_output ^ analog_output ^ expected_analog_output)) begin
                $display("PASS");
                $display("  Outputs: analog_output=%h",
                         analog_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: analog_output=%h",
                         expected_analog_output);
                $display("  Got:      analog_output=%h",
                         analog_output);
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
