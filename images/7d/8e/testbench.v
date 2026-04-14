`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg up_down;
    wire [1:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .up_down(up_down),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            up_down = 0;
            @(posedge clk);
            #1 reset = 0;

            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Verify Reset State", test_num);
            reset_dut();


            #1;



            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Increment once (0 to 1)", test_num);
            reset_dut();
            up_down = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Increment full cycle (0 to 0 wrap)", test_num);
            reset_dut();
            up_down = 1;
            repeat(4) @(posedge clk);
            #1 #1;
 check_outputs(2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Decrement once (0 to 3 wrap)", test_num);
            reset_dut();
            up_down = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Decrement multiple times (0 to 1)", test_num);
            reset_dut();
            up_down = 0;
            repeat(3) @(posedge clk);
            #1 #1;
 check_outputs(2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Direction Change (Up 2, Down 1)", test_num);
            reset_dut();
            up_down = 1;
            repeat(2) @(posedge clk);
            up_down = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(2'b01);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Maximum count and wrap up", test_num);
            reset_dut();
            up_down = 1;
            repeat(3) @(posedge clk);
            #1 #1;
 check_outputs(2'b11);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Reset override during operation", test_num);
            reset_dut();
            up_down = 1;
            repeat(2) @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;
            #1 #1;
 check_outputs(2'b00);
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
        input [1:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, reset, up_down, count);
    end

endmodule
