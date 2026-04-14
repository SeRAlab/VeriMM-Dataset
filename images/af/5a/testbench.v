`timescale 1ns/1ps

module up_down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset_n;
    reg up_down;
    wire [2:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter dut (
        .clk(clk),
        .enable(enable),
        .reset_n(reset_n),
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
        @(negedge clk);
        reset_n = 0;
        enable = 0;
        up_down = 1;
        @(posedge clk);
        #1;
        reset_n = 1;
    end
        endtask
    task testcase001;

    begin
        $display("Test 001: Synchronous Reset Check");
        reset_dut();
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        $display("Test 002: Counting up 3 times");
        reset_dut();
        @(negedge clk);
        enable = 1;
        up_down = 1;
        repeat(3) @(posedge clk);
        #1 #1;
 check_outputs(3'd3);
    end
        endtask

    task testcase003;

    begin
        $display("Test 003: Up counter rollover (7 to 0)");
        reset_dut();
        @(negedge clk);
        enable = 1;
        up_down = 1;
        repeat(8) @(posedge clk);
        #1 #1;
 check_outputs(3'd0);
    end
        endtask

    task testcase004;

    begin
        $display("Test 004: Down counter underflow (0 to 7)");
        reset_dut();
        @(negedge clk);
        enable = 1;
        up_down = 0;
        repeat(1) @(posedge clk);
        #1 #1;
 check_outputs(3'd7);
    end
        endtask

    task testcase005;

    begin
        $display("Test 005: Enable signal check (Disable at count 2)");
        reset_dut();
        @(negedge clk);
        enable = 1;
        up_down = 1;
        repeat(2) @(posedge clk);
        @(negedge clk);
        enable = 0;
        repeat(3) @(posedge clk);
        #1 #1;
 check_outputs(3'd2);
    end
        endtask

    task testcase006;

    begin
        $display("Test 006: Switch direction (Up to 4, then down 2)");
        reset_dut();
        @(negedge clk);
        enable = 1;
        up_down = 1;
        repeat(4) @(posedge clk);
        @(negedge clk);
        up_down = 0;
        repeat(2) @(posedge clk);
        #1 #1;
 check_outputs(3'd2);
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
        input [2:0] expected_count;
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
        $dumpvars(0,clk, enable, reset_n, up_down, count);
    end

endmodule
