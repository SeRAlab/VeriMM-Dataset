`timescale 1ns/1ps

module sync_up_down_counter_4bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg up;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sync_up_down_counter_4bit dut (
        .clk(clk),
        .rst(rst),
        .up(up),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            up = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Verifying Synchronous Reset...");
            reset_dut();

            #1;


            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Counting Up for 5 cycles...");
            reset_dut();
            up = 1;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(4'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Counting Down from 0 (Underflow)...");
            reset_dut();
            up = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Counting Up for 16 cycles (Overflow to 0)...");
            reset_dut();
            up = 1;
            repeat(16) @(posedge clk);
            #1 #1;
 check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Count Up 10 times, then Down 4 times...");
            reset_dut();
            up = 1;
            repeat(10) @(posedge clk);
            up = 0;
            repeat(4) @(posedge clk);
            #1 #1;
 check_outputs(4'd6);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Count Up 3, then Down 3 to Zero...");
            reset_dut();
            up = 1;
            repeat(3) @(posedge clk);
            up = 0;
            repeat(3) @(posedge clk);
            #1 #1;
 check_outputs(4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Counting Up to Maximum (15)...");
            reset_dut();
            up = 1;
            repeat(15) @(posedge clk);
            #1 #1;
 check_outputs(4'hF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: Counting Down 18 cycles (Two full underflows)...");
            reset_dut();
            up = 0;
            repeat(18) @(posedge clk);
            #1 #1;
 check_outputs(4'd14);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sync_up_down_counter_4bit Testbench");
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
        input [3:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, rst, up, q);
    end

endmodule
