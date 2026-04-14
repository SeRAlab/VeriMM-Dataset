`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg din;
    reg reset_n;
    wire dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .reset_n(reset_n),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset_n = 0;
        din = 0;
        repeat(2) @(posedge clk);
        #1 reset_n = 1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Output after reset", test_num);
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Single bit '1' propagation", test_num);

        din = 1;
        @(posedge clk);
        din = 0;
        @(posedge clk);

        #1 #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Single bit '0' propagation", test_num);


        din = 1;
        @(posedge clk);

        din = 0;
        @(posedge clk);

        din = 0;
        @(posedge clk);

        #1 #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Pipeline flow check", test_num);

        din = 1; @(posedge clk);
        din = 0; @(posedge clk);
        din = 1; @(posedge clk);

        #1 #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Mid-operation reset check", test_num);

        din = 1;
        @(posedge clk);
        din = 1;
        @(posedge clk);

        reset_n = 0;
        @(posedge clk);

        #1 #1;
 check_outputs(1'b0);
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
        input expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%b",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%b",
                         expected_dout);
                $display("  Got:      dout=%b",
                         dout);
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
        $dumpvars(0,clk, din, reset_n, dout);
    end

endmodule
