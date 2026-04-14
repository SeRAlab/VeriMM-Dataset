`timescale 1ns/1ps

module ADC_24to12_tb;

    // Testbench signals (sequential circuit)
    reg [23:0] analog_input;
    reg clk;
    reg reset;
    wire [11:0] digital_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ADC_24to12 dut (
        .analog_input(analog_input),
        .clk(clk),
        .reset(reset),
        .digital_output(digital_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        analog_input = 0;
        @(posedge clk);
        #2;
        reset = 0;
        @(posedge clk);
        #2;
    end
        endtask
    task testcase001;

    begin
        $display("\nTestcase 001: Minimum input value (0x000000)");
        reset_dut();
        analog_input = 24'h000000;
        @(posedge clk);
        #2;
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase002;

    begin
        $display("\nTestcase 002: Maximum input value (0xFFFFFF)");
        reset_dut();
        analog_input = 24'hFFFFFF;
        @(posedge clk);
        #2;
        #1;

        check_outputs(12'hFFF);
    end
        endtask

    task testcase003;

    begin
        $display("\nTestcase 003: Mid-range value (0x800000)");
        reset_dut();
        analog_input = 24'h800000;
        @(posedge clk);
        #2;
        #1;

        check_outputs(12'h800);
    end
        endtask

    task testcase004;

    begin
        $display("\nTestcase 004: Specific hex pattern (0xABCDEF)");
        reset_dut();
        analog_input = 24'hABCDEF;
        @(posedge clk);
        #2;
        #1;

        check_outputs(12'hABC);
    end
        endtask

    task testcase005;

    begin
        $display("\nTestcase 005: Low boundary check (0x000FFF)");
        reset_dut();
        analog_input = 24'h000FFF;
        @(posedge clk);
        #2;
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase006;

    begin
        $display("\nTestcase 006: High boundary check (0xFFF000)");
        reset_dut();
        analog_input = 24'hFFF000;
        @(posedge clk);
        #2;
        #1;

        check_outputs(12'hFFF);
    end
        endtask

    task testcase007;

    begin
        $display("\nTestcase 007: Alternating bits (0xAAAAAA)");
        reset_dut();
        analog_input = 24'hAAAAAA;
        @(posedge clk);
        #2;
        #1;

        check_outputs(12'hAAA);
    end
        endtask

    task testcase008;

    begin
        $display("\nTestcase 008: Alternating bits (0x555555)");
        reset_dut();
        analog_input = 24'h555555;
        @(posedge clk);
        #2;
        #1;

        check_outputs(12'h555);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ADC_24to12 Testbench");
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
        input [11:0] expected_digital_output;
        begin
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,analog_input, clk, reset, digital_output);
    end

endmodule
