`timescale 1ns/1ps

module counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg up_down;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter dut (
        .clk(clk),
        .rst(rst),
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
            rst = 1;
            up_down = 1;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Count Up 5 cycles...");
            reset_dut();
            up_down = 1;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(1, 4'd5);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Count Down 3 cycles from 0...");
            reset_dut();
            up_down = 0;
            repeat(3) @(posedge clk);
            #1 #1;
 check_outputs(2, 4'd13);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Overflow Check (15 + 1 = 0)...");
            reset_dut();
            up_down = 1;
            repeat(16) @(posedge clk);
            #1 #1;
 check_outputs(3, 4'd0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Underflow Check (0 - 1 = 15)...");
            reset_dut();
            up_down = 0;
            repeat(1) @(posedge clk);
            #1 #1;
 check_outputs(4, 4'd15);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Switch Direction (Up 10, then Down 4)...");
            reset_dut();
            up_down = 1;
            repeat(10) @(posedge clk);
            up_down = 0;
            repeat(4) @(posedge clk);
            #1 #1;
 check_outputs(5, 4'd6);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Reset during operation...");
            reset_dut();
            up_down = 1;
            repeat(7) @(posedge clk);
            rst = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(6, 4'd0);
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning testcase007: Count Up to 15...");
            reset_dut();
            up_down = 1;
            repeat(15) @(posedge clk);
            #1 #1;
 check_outputs(7, 4'd15);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [3:0] expected_count;
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
        $dumpvars(0,clk, rst, up_down, count);
    end

endmodule
