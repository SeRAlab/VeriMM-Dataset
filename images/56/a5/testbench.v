`timescale 1ns/1ps

module simple_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire [2:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_counter dut (
        .clk(clk),
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
        @(posedge clk);
        #1 rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Testing Reset state...", test_num);
        reset_dut();
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Testing count to 1...", test_num);
        reset_dut();
        @(posedge clk);
        #1 #1;
 check_outputs(3'b001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Testing count to max (7)...", test_num);
        reset_dut();
        repeat(7) @(posedge clk);
        #1 #1;
 check_outputs(3'b111);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Testing rollover (7 to 0)...", test_num);
        reset_dut();
        repeat(8) @(posedge clk);
        #1 #1;
 check_outputs(3'b000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Testing multiple rollovers (count to 19)...", test_num);
        reset_dut();

        repeat(19) @(posedge clk);
        #1 #1;
 check_outputs(3'b011);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("simple_counter Testbench");
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
        $dumpvars(0,clk, rst, count);
    end

endmodule
