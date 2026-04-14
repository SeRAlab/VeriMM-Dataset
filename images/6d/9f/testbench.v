`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg start;
    wire [2:0] cnt;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .start(start),
        .cnt(cnt),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Standard 6 to 0 countdown", test_num);
            reset_dut();


            start = 1;
            @(posedge clk);
            start = 0;



            repeat(6) @(posedge clk);

            #1;
            #1;

            check_outputs(3'b000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Mid-point check (expecting 3)", test_num);
            reset_dut();

            start = 1;
            @(posedge clk);
            start = 0;


            repeat(3) @(posedge clk);

            #1;
            #1;

            check_outputs(3'b011, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Hold start signal high", test_num);
            reset_dut();

            start = 1;
            repeat(3) @(posedge clk);

            #1;

            #1;


            check_outputs(3'b110, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Restart countdown mid-way", test_num);
            reset_dut();

            start = 1; @(posedge clk); start = 0;
            repeat(3) @(posedge clk);

            start = 1; @(posedge clk); start = 0;
            repeat(2) @(posedge clk);

            #1;
            #1;

            check_outputs(3'b100, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Check value 1 cycle before done", test_num);
            reset_dut();

            start = 1; @(posedge clk); start = 0;
            repeat(5) @(posedge clk);

            #1;
            #1;

            check_outputs(3'b001, 1'b0);
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
        input [2:0] expected_cnt;
        input expected_done;
        begin
            if (expected_cnt === (expected_cnt ^ cnt ^ expected_cnt) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: cnt=%h, done=%b",
                         cnt, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cnt=%h, done=%b",
                         expected_cnt, expected_done);
                $display("  Got:      cnt=%h, done=%b",
                         cnt, done);
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
        $dumpvars(0,clk, start, cnt, done);
    end

endmodule
