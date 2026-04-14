`timescale 1ns/1ps

module up_down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg dir;
    reg rst;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter dut (
        .clk(clk),
        .dir(dir),
        .rst(rst),
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
        dir = 1;
        @(posedge clk);
        #1;
        rst = 0;
    end
        endtask
    task testcase001;

    begin
        $display("\nTestcase 001: Verify Synchronous Reset");
        reset_dut();

        #1;


        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        $display("\nTestcase 002: Increment Up 5 times");
        reset_dut();
        dir = 1;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase003;

    begin
        $display("\nTestcase 003: Decrement Down (Underflow check)");
        reset_dut();
        dir = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase004;

    begin
        $display("\nTestcase 004: Increment to Overflow (16 cycles)");
        reset_dut();
        dir = 1;
        repeat(16) @(posedge clk);
        #1;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase005;

    begin
        $display("\nTestcase 005: Switch Direction (Up 10, then Down 4)");
        reset_dut();
        dir = 1;
        repeat(10) @(posedge clk);
        dir = 0;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(4'h6);
    end
        endtask

    task testcase006;

    begin
        $display("\nTestcase 006: Decrement multiple times from reset");
        reset_dut();
        dir = 0;
        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(4'hD);
    end
        endtask

    task testcase007;

    begin
        $display("\nTestcase 007: Count Up to Maximum");
        reset_dut();
        dir = 1;
        repeat(15) @(posedge clk);
        #1;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase008;

    begin
        $display("\nTestcase 008: Reset during counting");
        reset_dut();
        dir = 1;
        repeat(8) @(posedge clk);
        rst = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'h0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("up_down_counter Testbench");
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
        $dumpvars(0,clk, dir, rst, count);
    end

endmodule
