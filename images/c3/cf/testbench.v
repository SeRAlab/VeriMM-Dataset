`timescale 1ns/1ps

module configurable_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] max_count;
    reg reset;
    wire [7:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    configurable_counter dut (
        .clk(clk),
        .max_count(max_count),
        .reset(reset),
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
        max_count = 8'h00;
        @(posedge clk);
        #1 reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Basic Increment", test_num);
        reset_dut();
        max_count = 8'd10;
        repeat(5) @(posedge clk);
        #1 #1;
 check_outputs(8'd5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Exact Max Count", test_num);
        reset_dut();
        max_count = 8'd10;
        repeat(10) @(posedge clk);
        #1 #1;
 check_outputs(8'd10);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Wrap Around Logic", test_num);
        reset_dut();
        max_count = 8'd5;
        repeat(6) @(posedge clk);
        #1 #1;
 check_outputs(8'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Boundary Value Zero", test_num);
        reset_dut();
        max_count = 8'd0;
        repeat(2) @(posedge clk);
        #1 #1;
 check_outputs(8'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Full Range Max Value", test_num);
        reset_dut();
        max_count = 8'd255;
        repeat(255) @(posedge clk);
        #1 #1;
 check_outputs(8'd255);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Dynamic Max Count", test_num);
        reset_dut();
        max_count = 8'd20;
        repeat(5) @(posedge clk);
        max_count = 8'd5;
        @(posedge clk);
        #1 #1;
 check_outputs(8'd0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("configurable_counter Testbench");
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
        input [7:0] expected_count;
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
        $dumpvars(0,clk, max_count, reset, count);
    end

endmodule
