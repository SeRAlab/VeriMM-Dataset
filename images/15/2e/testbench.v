`timescale 1ns/1ps

module DAC_24bit_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] digital_input;
    reg [1:0] gain_control;
    wire [31:0] analog_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC_24bit dut (
        .digital_input(digital_input),
        .gain_control(gain_control),
        .analog_output(analog_output)
    );
    task testcase001;

    begin
        test_num = 1;
        digital_input = 24'h000000;
        gain_control = 2'b00;
        $display("Test 001: Zero input, Gain x1");
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        digital_input = 24'h000001;
        gain_control = 2'b00;
        $display("Test 002: Small input (1), Gain x1");
        #1;

        check_outputs(32'h00000100);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        digital_input = 24'hFFFFFF;
        gain_control = 2'b00;
        $display("Test 003: Full scale input, Gain x1");
        #1;

        check_outputs(32'hFFFFFF00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        digital_input = 24'h400000;
        gain_control = 2'b01;
        $display("Test 004: Mid-scale (0x400000), Gain x2");
        #1;

        check_outputs(32'h80000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        digital_input = 24'h7FFFFF;
        gain_control = 2'b01;
        $display("Test 005: Boundary input (0x7FFFFF), Gain x2");
        #1;

        check_outputs(32'hFFFFFE00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        digital_input = 24'h800000;
        gain_control = 2'b01;
        $display("Test 006: Saturation check (0x800000), Gain x2");
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        digital_input = 24'h000001;
        gain_control = 2'b10;
        $display("Test 007: Small input (1), Gain x4");
        #1;

        check_outputs(32'h00000400);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        digital_input = 24'h200000;
        gain_control = 2'b10;
        $display("Test 008: Quarter scale (0x200000), Gain x4");
        #1;

        check_outputs(32'h80000000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        digital_input = 24'h3FFFFF;
        gain_control = 2'b10;
        $display("Test 009: Boundary input (0x3FFFFF), Gain x4");
        #1;

        check_outputs(32'hFFFFFC00);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        digital_input = 24'hFFFFFF;
        gain_control = 2'b10;
        $display("Test 010: Full scale input, Gain x4");
        #1;

        check_outputs(32'hFFFFFFFF);
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
        input [31:0] expected_analog_output;
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
