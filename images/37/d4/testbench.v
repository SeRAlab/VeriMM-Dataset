`timescale 1ns/1ps

module DVFS_Controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] performance_level;
    reg reset;
    wire [3:0] frequency;
    wire [3:0] voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DVFS_Controller dut (
        .clk(clk),
        .performance_level(performance_level),
        .reset(reset),
        .frequency(frequency),
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
            performance_level = 2'b00;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Verify default state after Reset (Level 0)");
            test_num = test_num + 1;
            reset_dut();

            #1;


            check_outputs(4'd1, 4'd5);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Transition from Level 0 to Level 1");
            test_num = test_num + 1;
            reset_dut();
            performance_level = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd2, 4'd8);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Transition from Level 0 to Level 2");
            test_num = test_num + 1;
            reset_dut();
            performance_level = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3, 4'd10);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Transition from Level 0 to Level 3");
            test_num = test_num + 1;
            reset_dut();
            performance_level = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd4, 4'd12);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Sequential transition (Level 3 then down to Level 1)");
            test_num = test_num + 1;
            reset_dut();

            performance_level = 2'b11;
            @(posedge clk);

            performance_level = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd2, 4'd8);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Verify Reset override from Level 2");
            test_num = test_num + 1;
            reset_dut();

            performance_level = 2'b10;
            @(posedge clk);
            #1;

            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd1, 4'd5);
            reset = 0;
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Stability check at Level 2");
            test_num = test_num + 1;
            reset_dut();
            performance_level = 2'b10;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3, 4'd10);
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
        input [3:0] expected_frequency;
        input [3:0] expected_voltage;
        begin
            if (expected_frequency === (expected_frequency ^ frequency ^ expected_frequency) &&
                expected_voltage === (expected_voltage ^ voltage ^ expected_voltage)) begin
                $display("PASS");
                $display("  Outputs: frequency=%h, voltage=%h",
                         frequency, voltage);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frequency=%h, voltage=%h",
                         expected_frequency, expected_voltage);
                $display("  Got:      frequency=%h, voltage=%h",
                         frequency, voltage);
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
        $dumpvars(0,clk, performance_level, reset, frequency, voltage);
    end

endmodule
