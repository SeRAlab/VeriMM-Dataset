`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg reset;
    reg select;
    wire [7:0] and_out;
    wire [3:0] counter_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .reset(reset),
        .select(select),
        .and_out(and_out),
        .counter_out(counter_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        d = 8'h00;
        select = 0;
        @(negedge clk);
        @(posedge clk);
        #1 reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Initial Reset State", test_num);
        reset_dut();



        #1 #1;
 check_outputs(8'h00, 4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Register loading on negative edge", test_num);
        reset_dut();
        d = 8'hAA;
        @(negedge clk);


        #1 #1;
 check_outputs(8'h00, 4'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Counter increment and AND alignment", test_num);
        reset_dut();


        repeat(4) @(posedge clk);


        #1 #1;
 check_outputs(8'h04, 4'h4);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select high forcing counter_out to 0", test_num);
        reset_dut();
        repeat(2) @(posedge clk);
        select = 1;


        #1 #1;
 check_outputs(8'h00, 4'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multi-bit AND operation check", test_num);
        reset_dut();
        d = 8'h0F;
        @(negedge clk);
        repeat(7) @(posedge clk);


        #1 #1;
 check_outputs(8'h07, 4'h7);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Counter reset on positive edge when select is high", test_num);
        reset_dut();
        repeat(5) @(posedge clk);
        select = 1;
        @(posedge clk);
        select = 0;
        #1 #1;
 check_outputs(8'h00, 4'h0);
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
        input [7:0] expected_and_out;
        input [3:0] expected_counter_out;
        begin
            if (expected_and_out === (expected_and_out ^ and_out ^ expected_and_out) &&
                expected_counter_out === (expected_counter_out ^ counter_out ^ expected_counter_out)) begin
                $display("PASS");
                $display("  Outputs: and_out=%h, counter_out=%h",
                         and_out, counter_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: and_out=%h, counter_out=%h",
                         expected_and_out, expected_counter_out);
                $display("  Got:      and_out=%h, counter_out=%h",
                         and_out, counter_out);
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
        $dumpvars(0,clk, d, reset, select, and_out, counter_out);
    end

endmodule
