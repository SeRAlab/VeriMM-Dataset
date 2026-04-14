`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] din;
    reg load;
    reg reset;
    wire [3:0] sro;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .load(load),
        .reset(reset),
        .sro(sro)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        load = 0;
        din = 4'b0;
        @(posedge clk);
        #1 reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Synchronous Reset", test_num);
        reset_dut();

        #1;


        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Load Parallel Data", test_num);
        reset_dut();

        din = 4'b1011;
        load = 1;
        @(posedge clk);
        #1 load = 0;

        #1;


        check_outputs(4'b1011);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Single Shift Left", test_num);
        reset_dut();


        din = 4'b0101;
        load = 1;
        @(posedge clk);


        load = 0;
        din = 4'b1000;
        @(posedge clk);
        #1;

        #1;


        check_outputs(4'b1011);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Multi-cycle Shift", test_num);
        reset_dut();

        load = 0;

        din = 4'b1000; @(posedge clk);
        din = 4'b0000; @(posedge clk);
        din = 4'b1000; @(posedge clk);
        din = 4'b0000; @(posedge clk);

        #1 #1;
 check_outputs(4'b1010);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Reset Priority", test_num);
        reset_dut();


        din = 4'b1111;
        load = 1;
        @(posedge clk);


        reset = 1;
        din = 4'b1010;
        load = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(4'b0000);
        reset = 0;
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Load Priority Over Shift", test_num);
        reset_dut();


        din = 4'b0101;
        load = 1;
        @(posedge clk);



        din = 4'b1100;
        load = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(4'b1100);
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
        input [3:0] expected_sro;
        begin
            if (expected_sro === (expected_sro ^ sro ^ expected_sro)) begin
                $display("PASS");
                $display("  Outputs: sro=%h",
                         sro);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sro=%h",
                         expected_sro);
                $display("  Got:      sro=%h",
                         sro);
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
        $dumpvars(0,clk, din, load, reset, sro);
    end

endmodule
