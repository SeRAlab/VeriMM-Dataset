`timescale 1ns/1ps

module DVFS_Controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [1:0] voltage_level;
    wire [1:0] frequency_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DVFS_Controller dut (
        .clk(clk),
        .enable(enable),
        .voltage_level(voltage_level),
        .frequency_output(frequency_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            voltage_level = 2'b00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            enable = 0;
            voltage_level = 2'b11;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            enable = 1;
            voltage_level = 2'b00;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            enable = 1;
            voltage_level = 2'b01;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            enable = 1;
            voltage_level = 2'b10;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            enable = 1;
            voltage_level = 2'b11;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            enable = 1;
            voltage_level = 2'b01;
            @(posedge clk);
            voltage_level = 2'b11;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            enable = 1;
            voltage_level = 2'b11;
            @(posedge clk);
            enable = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            enable = 0;
            voltage_level = 2'b10;
            @(posedge clk);
            enable = 1;
            repeat(2) @(posedge clk);
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
        input [1:0] expected_frequency_output;
        begin
            if (expected_frequency_output === (expected_frequency_output ^ frequency_output ^ expected_frequency_output)) begin
                $display("PASS");
                $display("  Outputs: frequency_output=%h",
                         frequency_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frequency_output=%h",
                         expected_frequency_output);
                $display("  Got:      frequency_output=%h",
                         frequency_output);
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
        $dumpvars(0,clk, enable, voltage_level, frequency_output);
    end

endmodule
