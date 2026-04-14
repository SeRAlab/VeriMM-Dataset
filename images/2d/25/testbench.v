`timescale 1ns/1ps

module DVFS_Controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [1:0] voltage_level;
    wire [1:0] frequency_level;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DVFS_Controller dut (
        .clk(clk),
        .reset(reset),
        .voltage_level(voltage_level),
        .frequency_level(frequency_level)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            voltage_level = 2'b00;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Executing testcase001: Reset State Check");
            reset_dut();

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            $display("Executing testcase002: Transition to Medium Frequency");
            reset_dut();
            voltage_level = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            $display("Executing testcase003: Transition to High Frequency");
            reset_dut();
            voltage_level = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            $display("Executing testcase004: Sequential increase Low -> Medium -> High");
            reset_dut();

            voltage_level = 2'b01;
            @(posedge clk);
            #1;

            voltage_level = 2'b10;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b10);
        end
        endtask

    task testcase005;

        begin
            $display("Executing testcase005: Sequential decrease High -> Low");
            reset_dut();

            voltage_level = 2'b10;
            @(posedge clk);
            #1;

            voltage_level = 2'b00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            $display("Executing testcase006: Stability Check at Medium");
            reset_dut();

            voltage_level = 2'b01;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase007;

        begin
            $display("Executing testcase007: Rapid Toggle Check");
            reset_dut();

            voltage_level = 2'b10;
            @(posedge clk);
            voltage_level = 2'b01;
            @(posedge clk);
            voltage_level = 2'b10;
            @(posedge clk);
            #1;

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
        $display("DVFS_Controller Testbench");
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
        input [1:0] expected_frequency_level;
        begin
            if (expected_frequency_level === (expected_frequency_level ^ frequency_level ^ expected_frequency_level)) begin
                $display("PASS");
                $display("  Outputs: frequency_level=%h",
                         frequency_level);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frequency_level=%h",
                         expected_frequency_level);
                $display("  Got:      frequency_level=%h",
                         frequency_level);
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
        $dumpvars(0,clk, reset, voltage_level, frequency_level);
    end

endmodule
