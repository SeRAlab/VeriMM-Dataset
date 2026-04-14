`timescale 1ns/1ps

module DVFS_Controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] temperature;
    wire [1:0] frequency;
    wire [1:0] state;
    wire [1:0] voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DVFS_Controller dut (
        .clk(clk),
        .reset(reset),
        .temperature(temperature),
        .frequency(frequency),
        .state(state),
        .voltage(voltage)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            temperature = 8'd60;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial state after reset (Neutral Temp)", test_num);
            reset_dut();

            #1;


            check_outputs(2'd1, 2'd1, 2'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Transition MEDIUM -> LOW (Temp > 75)", test_num);
            reset_dut();
            temperature = 8'd80;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'd0, 2'd0, 2'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Transition MEDIUM -> HIGH (Temp < 50)", test_num);
            reset_dut();
            temperature = 8'd40;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'd2, 2'd2, 2'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Transition HIGH -> MEDIUM (High Temp while in HIGH state)", test_num);
            reset_dut();


            temperature = 8'd40;
            @(posedge clk);
            #1;


            temperature = 8'd85;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd1, 2'd1, 2'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Transition LOW -> MEDIUM (Low Temp while in LOW state)", test_num);
            reset_dut();


            temperature = 8'd90;
            @(posedge clk);
            #1;


            temperature = 8'd30;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd1, 2'd1, 2'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Saturate at LOW (High Temp while already LOW)", test_num);
            reset_dut();

            temperature = 8'd80;
            @(posedge clk);
            #1;
            temperature = 8'd85;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd0, 2'd0, 2'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Saturate at HIGH (Low Temp while already HIGH)", test_num);
            reset_dut();

            temperature = 8'd40;
            @(posedge clk);
            #1;
            temperature = 8'd35;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd2, 2'd2, 2'd2);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Boundary check (Temp 75 and 50)", test_num);
            reset_dut();

            temperature = 8'd75;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd1, 2'd1, 2'd1);

            temperature = 8'd50;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd1, 2'd1, 2'd1);
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
        input [1:0] expected_frequency;
        input [1:0] expected_state;
        input [1:0] expected_voltage;
        begin
            if (expected_frequency === (expected_frequency ^ frequency ^ expected_frequency) &&
                expected_state === (expected_state ^ state ^ expected_state) &&
                expected_voltage === (expected_voltage ^ voltage ^ expected_voltage)) begin
                $display("PASS");
                $display("  Outputs: frequency=%h, state=%h, voltage=%h",
                         frequency, state, voltage);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frequency=%h, state=%h, voltage=%h",
                         expected_frequency, expected_state, expected_voltage);
                $display("  Got:      frequency=%h, state=%h, voltage=%h",
                         frequency, state, voltage);
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
        $dumpvars(0,clk, reset, temperature, frequency, state, voltage);
    end

endmodule
