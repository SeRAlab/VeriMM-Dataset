`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rstn;
    reg [1:0] set;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rstn(rstn),
        .set(set),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rstn = 0;
            set = 2'b00;
            repeat(2) @(posedge clk);
            #1 rstn = 1;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset State", test_num);
            reset_dut();

            repeat(5) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Set Timer 01 and Wait for Completion", test_num);
            reset_dut();
            @(posedge clk);
            set = 2'b01;
            @(posedge clk);
            set = 2'b00;



            repeat(200) @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Verify Busy Status during Counting", test_num);
            reset_dut();
            @(posedge clk);
            set = 2'b11;
            @(posedge clk);
            set = 2'b00;


            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Set Timer 10 and Wait for Completion", test_num);
            reset_dut();
            @(posedge clk);
            set = 2'b10;
            @(posedge clk);
            set = 2'b00;

            repeat(500) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Reset During Operation", test_num);
            reset_dut();
            @(posedge clk);
            set = 2'b11;
            @(posedge clk);
            set = 2'b00;

            repeat(10) @(posedge clk);


            rstn = 0;
            #20;
            rstn = 1;


            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Set Timer 11 and Wait for Completion", test_num);
            reset_dut();
            @(posedge clk);
            set = 2'b11;
            @(posedge clk);
            set = 2'b00;

            repeat(1000) @(posedge clk);
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
        input expected_ready;
        begin
            if (expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: ready=%b",
                         ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ready=%b",
                         expected_ready);
                $display("  Got:      ready=%b",
                         ready);
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
        $dumpvars(0,clk, rstn, set, ready);
    end

endmodule
