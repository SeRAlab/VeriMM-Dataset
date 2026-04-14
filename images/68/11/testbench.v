`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg button;
    reg clk;
    reg sensor;
    wire green;
    wire red;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .button(button),
        .clk(clk),
        .sensor(sensor),
        .green(green),
        .red(red)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            button = 0;
            sensor = 0;
            repeat(15) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Checking idle state (Red)");
            reset_dut();

            #1;


            check_outputs(0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Button press transition to Green");
            reset_dut();
            @(posedge clk);
            button = 1;
            @(posedge clk);
            button = 0;

            #1;


            check_outputs(1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Full 10-cycle Green duration timeout");
            reset_dut();
            @(posedge clk);
            button = 1;
            @(posedge clk);
            button = 0;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Sensor interrupt forces Red transition");
            reset_dut();
            @(posedge clk);
            button = 1;
            @(posedge clk);
            button = 0;

            repeat(3) @(posedge clk);

            sensor = 1;
            @(posedge clk);
            sensor = 0;

            #1;


            check_outputs(0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Sensor active immediately after button");
            reset_dut();
            @(posedge clk);
            button = 1;
            @(posedge clk);
            button = 0;
            sensor = 1;
            @(posedge clk);
            sensor = 0;

            #1;


            check_outputs(0, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input expected_green;
        input expected_red;
        begin
            if (expected_green === (expected_green ^ green ^ expected_green) &&
                expected_red === (expected_red ^ red ^ expected_red)) begin
                $display("PASS");
                $display("  Outputs: green=%b, red=%b",
                         green, red);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: green=%b, red=%b",
                         expected_green, expected_red);
                $display("  Got:      green=%b, red=%b",
                         green, red);
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
        $dumpvars(0,button, clk, sensor, green, red);
    end

endmodule
