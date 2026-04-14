`timescale 1ns/1ps

module up_down_counter_12bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst;
    reg up_down;
    wire [11:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter_12bit dut (
        .clk(clk),
        .en(en),
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
        en = 0;
        up_down = 0;
        @(posedge clk);
        #1 rst = 0;
    end
        endtask
    task testcase001;

    begin
        $display("\nRunning Testcase 001: Reset Check");
        reset_dut();
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase002;

    begin
        $display("\nRunning Testcase 002: Basic Up Counting (10 steps)");
        reset_dut();
        en = 1;
        up_down = 1;
        repeat(10) @(posedge clk);
        #1 #1;
 check_outputs(12'd10);
    end
        endtask

    task testcase003;

    begin
        $display("\nRunning Testcase 003: Underflow Check (0 -> FFF)");
        reset_dut();
        en = 1;
        up_down = 0;
        repeat(1) @(posedge clk);
        #1 #1;
 check_outputs(12'hFFF);
    end
        endtask

    task testcase004;

    begin
        $display("\nRunning Testcase 004: Enable Signal Logic");
        reset_dut();
        en = 1;
        up_down = 1;
        repeat(5) @(posedge clk);
        en = 0;
        repeat(5) @(posedge clk);
        #1 #1;
 check_outputs(12'd5);
    end
        endtask

    task testcase005;

    begin
        $display("\nRunning Testcase 005: Direction Switching");
        reset_dut();
        en = 1;
        up_down = 1;
        repeat(15) @(posedge clk);
        up_down = 0;
        repeat(5) @(posedge clk);
        #1 #1;
 check_outputs(12'd10);
    end
        endtask

    task testcase006;

    begin
        $display("\nRunning Testcase 006: Reset Priority Check");
        reset_dut();
        en = 1;
        up_down = 1;
        repeat(20) @(posedge clk);
        rst = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(12'h000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("up_down_counter_12bit Testbench");
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
        input [11:0] expected_count;
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
        $dumpvars(0,clk, en, rst, up_down, count);
    end

endmodule
