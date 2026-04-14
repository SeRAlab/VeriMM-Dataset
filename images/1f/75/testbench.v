`timescale 1ns/1ps

module VCO_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] control_voltage;
    wire [3:0] frequency;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    VCO dut (
        .clk(clk),
        .control_voltage(control_voltage),
        .frequency(frequency)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            test_num = test_num + 1;
            control_voltage = 3'b000;

            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Running Testcase 001: Max Frequency (CV=111)");
            control_voltage = 3'b111;


            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase002;

        begin


            $display("Running Testcase 002: Min Frequency (CV=000)");
            control_voltage = 3'b000;

            repeat(16) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Mid Frequency (CV=011)");
            control_voltage = 3'b011;

            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd10);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Overflow Check (CV=111)");
            control_voltage = 3'b111;

            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd4);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("VCO Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [3:0] expected_frequency;
        begin
            if (expected_frequency === (expected_frequency ^ frequency ^ expected_frequency)) begin
                $display("PASS");
                $display("  Outputs: frequency=%h",
                         frequency);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frequency=%h",
                         expected_frequency);
                $display("  Got:      frequency=%h",
                         frequency);
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
        $dumpvars(0,clk, control_voltage, frequency);
    end

endmodule
