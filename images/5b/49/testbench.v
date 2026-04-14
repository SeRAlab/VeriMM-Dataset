`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg down;
    reg up;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .down(down),
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
            up = 0;
            down = 0;


            force dut.q = 0;
            repeat (2) @(posedge clk);
            release dut.q;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Increment once", test_num);
            reset_dut();
            up = 1; down = 0;
            @(posedge clk);
            #1;
            up = 0;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Increment 5 times", test_num);
            reset_dut();
            up = 1; down = 0;
            repeat (5) @(posedge clk);
            #1;
            up = 0;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Overflow check (16 increments)", test_num);
            reset_dut();
            up = 1; down = 0;
            repeat (16) @(posedge clk);
            #1;
            up = 0;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Decrement once from zero", test_num);
            reset_dut();
            up = 0; down = 1;
            @(posedge clk);
            #1;
            down = 0;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Decrement 4 times from zero", test_num);
            reset_dut();
            up = 0; down = 1;
            repeat (4) @(posedge clk);
            #1;
            down = 0;
            #1;

            check_outputs(4'd12);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Up 10 steps, Down 3 steps", test_num);
            reset_dut();
            up = 1; down = 0;
            repeat (10) @(posedge clk);
            up = 0; down = 1;
            repeat (3) @(posedge clk);
            #1;
            down = 0;
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Both Up and Down high", test_num);
            reset_dut();
            up = 1; down = 1;
            repeat (5) @(posedge clk);
            #1;
            up = 0; down = 0;

            #1;


            check_outputs(4'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Neither Up nor Down high", test_num);
            reset_dut();
            up = 0; down = 0;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Large count up then large count down", test_num);
            reset_dut();
            up = 1; down = 0;
            repeat (20) @(posedge clk);
            up = 0; down = 1;
            repeat (2) @(posedge clk);
            #1;
            down = 0;
            #1;

            check_outputs(4'd2);
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
        testcase007();
        testcase008();
        testcase009();
        
        
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
        $dumpvars(0,clk, down, up, q);
    end

endmodule
