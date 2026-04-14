`timescale 1ns/1ps

module dvfs_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] frequency_level;
    reg reset;
    reg [3:0] voltage_level;
    wire control_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dvfs_controller dut (
        .clk(clk),
        .frequency_level(frequency_level),
        .reset(reset),
        .voltage_level(voltage_level),
        .control_signal(control_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            voltage_level = 0;
            frequency_level = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset and Zero Inputs...");
            reset_dut();
            voltage_level = 4'h0;
            frequency_level = 4'h0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: High Voltage, Low Frequency...");
            reset_dut();
            voltage_level = 4'hF;
            frequency_level = 4'h2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Low Voltage, High Frequency...");
            reset_dut();
            voltage_level = 4'h1;
            frequency_level = 4'hE;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Balanced Mid-range Values...");
            reset_dut();
            voltage_level = 4'h8;
            frequency_level = 4'h8;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Maximum Levels...");
            reset_dut();
            voltage_level = 4'hF;
            frequency_level = 4'hF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Sequential Rapid Changes...");
            reset_dut();

            voltage_level = 4'hA; frequency_level = 4'h5;
            @(posedge clk);
            #1;

            voltage_level = 4'h3; frequency_level = 4'hC;
            @(posedge clk);
            #1;

            voltage_level = 4'h5; frequency_level = 4'h5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dvfs_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input expected_control_signal;
        begin
            if (expected_control_signal === (expected_control_signal ^ control_signal ^ expected_control_signal)) begin
                $display("PASS");
                $display("  Outputs: control_signal=%b",
                         control_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: control_signal=%b",
                         expected_control_signal);
                $display("  Got:      control_signal=%b",
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, frequency_level, reset, voltage_level, control_signal);
    end

endmodule
