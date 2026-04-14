`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] data_out;
    reg [2:0] data_ready;
    reg rst;
    wire [2:0] humid;
    wire [2:0] press;
    wire [2:0] temp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_out(data_out),
        .data_ready(data_ready),
        .rst(rst),
        .humid(humid),
        .press(press),
        .temp(temp)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        data_ready = 3'b000;
        data_out = 3'b000;
        repeat(2) @(posedge clk);
        #1 rst = 0;
        repeat(1) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase 001: Checking reset state...");

        #1;


        check_outputs(3'b000, 3'b000, 3'b000);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase 002: Reading data from Sensor 0...");
        @(posedge clk);
        data_ready = 3'b001;
        data_out = 3'b001;

        repeat(5) @(posedge clk);
        data_ready = 3'b000;
        #1;

        check_outputs(3'b001, 3'b001, 3'b001);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase 003: Reading data from all sensors (all high)...");
        @(posedge clk);
        data_ready = 3'b111;
        data_out = 3'b111;
        repeat(5) @(posedge clk);
        data_ready = 3'b000;
        #1;

        check_outputs(3'b111, 3'b111, 3'b111);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase 004: Sensors ready one after another...");


        @(posedge clk);
        data_ready = 3'b010;
        data_out = 3'b010;
        repeat(4) @(posedge clk);


        data_ready = 3'b100;
        data_out = 3'b100;
        repeat(4) @(posedge clk);

        data_ready = 3'b000;
        #1;

        check_outputs(3'b110, 3'b110, 3'b110);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase 005: Verifying data persistence after ready drops...");

        @(posedge clk);
        data_ready = 3'b101;
        data_out = 3'b101;
        repeat(5) @(posedge clk);


        data_ready = 3'b000;
        data_out = 3'b010;
        repeat(2) @(posedge clk);

        #1;


        check_outputs(3'b101, 3'b101, 3'b101);
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
        input [2:0] expected_humid;
        input [2:0] expected_press;
        input [2:0] expected_temp;
        begin
            if (expected_humid === (expected_humid ^ humid ^ expected_humid) &&
                expected_press === (expected_press ^ press ^ expected_press) &&
                expected_temp === (expected_temp ^ temp ^ expected_temp)) begin
                $display("PASS");
                $display("  Outputs: humid=%h, press=%h, temp=%h",
                         humid, press, temp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: humid=%h, press=%h, temp=%h",
                         expected_humid, expected_press, expected_temp);
                $display("  Got:      humid=%h, press=%h, temp=%h",
                         humid, press, temp);
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
        $dumpvars(0,clk, data_out, data_ready, rst, humid, press, temp);
    end

endmodule
