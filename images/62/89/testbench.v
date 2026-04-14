`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg reset;
    reg set;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .reset(reset),
        .set(set),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        d = 0;
        reset = 1;
        set = 0;
        @(posedge clk);
        #2;
        reset = 0;
        #2;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %0d: Asynchronous Reset check", test_num);
        d = 1;
        set = 0;
        reset = 1;
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %0d: Asynchronous Set check", test_num);
        d = 0;
        reset = 0;
        set = 1;
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %0d: Synchronous Data Load (D=1)", test_num);
        reset = 0;
        set = 0;
        d = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %0d: Synchronous Data Load (D=0)", test_num);

        set = 1; #2; set = 0;
        d = 0;
        reset = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %0d: Reset Priority over Set", test_num);
        d = 1;
        set = 1;
        reset = 1;
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Testcase %0d: Set Priority over D input", test_num);
        reset = 0;
        set = 1;
        d = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        $display("Testcase %0d: Data retention (no clock edge)", test_num);

        reset = 0; set = 0; d = 1;
        @(posedge clk);
        #2;

        d = 0;
        #10;
        #1;

        check_outputs(1'b1);
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
        input expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%b",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b",
                         expected_q);
                $display("  Got:      q=%b",
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
        $dumpvars(0,clk, d, reset, set, q);
    end

endmodule
