`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [15:0] datain;
    wire dac_clock;
    wire dac_data;
    wire dac_leftright;
    wire load;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .datain(datain),
        .dac_clock(dac_clock),
        .dac_data(dac_data),
        .dac_leftright(dac_leftright),
        .load(load)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            datain = 16'h0000;


            repeat(10) @(posedge clock);
            $display("DUT Initialized");
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            datain = 16'h0000;


            repeat(128) @(posedge clock);

            $display("Testcase 001: Checking All-Zeros Input");



            #1;




            check_outputs(dac_clock, 1'b0, dac_leftright, load);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            datain = 16'hFFFF;


            repeat(128) @(posedge clock);

            $display("Testcase 002: Checking All-Ones Input");

            #1;


            check_outputs(dac_clock, 1'b1, dac_leftright, load);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            datain = 16'h8000;



            wait(dac_leftright == 1'b1);
            repeat(2) @(posedge clock);

            $display("Testcase 003: Checking MSB transmission for 16'h8000");

            #1;


            check_outputs(dac_clock, 1'b1, dac_leftright, load);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            datain = 16'h0001;


            wait(dac_leftright == 1'b1);
            repeat(30) @(posedge dac_clock);

            $display("Testcase 004: Checking LSB transmission for 16'h0001");

            #1;


            check_outputs(dac_clock, 1'b1, dac_leftright, load);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            datain = 16'hAAAA;


            wait(dac_leftright == 1'b0);
            repeat(5) @(posedge clock);

            $display("Testcase 005: Verifying Left/Right signal and data toggle");


            #1;



            check_outputs(dac_clock, dac_data, 1'b0, load);
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
        input expected_dac_clock;
        input expected_dac_data;
        input expected_dac_leftright;
        input expected_load;
        begin
            if (expected_dac_clock === (expected_dac_clock ^ dac_clock ^ expected_dac_clock) &&
                expected_dac_data === (expected_dac_data ^ dac_data ^ expected_dac_data) &&
                expected_dac_leftright === (expected_dac_leftright ^ dac_leftright ^ expected_dac_leftright) &&
                expected_load === (expected_load ^ load ^ expected_load)) begin
                $display("PASS");
                $display("  Outputs: dac_clock=%b, dac_data=%b, dac_leftright=%b, load=%b",
                         dac_clock, dac_data, dac_leftright, load);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dac_clock=%b, dac_data=%b, dac_leftright=%b, load=%b",
                         expected_dac_clock, expected_dac_data, expected_dac_leftright, expected_load);
                $display("  Got:      dac_clock=%b, dac_data=%b, dac_leftright=%b, load=%b",
                         dac_clock, dac_data, dac_leftright, load);
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
        $dumpvars(0,clock, datain, dac_clock, dac_data, dac_leftright, load);
    end

endmodule
