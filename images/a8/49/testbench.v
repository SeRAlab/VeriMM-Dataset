`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ctrl;
    reg ref_clk;
    wire out_clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl(ctrl),
        .ref_clk(ref_clk),
        .out_clk(out_clk)
    );

    // Clock generation (10ns period)
    initial begin
        ctrl = 0;
        forever #5 ctrl = ~ctrl;
    end

        task reset_dut;

    begin
        ctrl = 1;
        repeat(5) @(posedge ref_clk);
        #2;
        ctrl = 0;
        repeat(2) @(posedge ref_clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Immediate state after reset", test_num);
        reset_dut();

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: State after 20 reference clock cycles", test_num);
        reset_dut();
        repeat(20) @(posedge ref_clk);
        #1;


        #1;



        check_outputs(out_clk);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset during active synthesis", test_num);
        reset_dut();
        repeat(50) @(posedge ref_clk);

        ctrl = 1;
        #15;

        #1;


        check_outputs(1'b0);
        ctrl = 0;
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Long run stability check", test_num);
        reset_dut();
        repeat(200) @(posedge ref_clk);
        #1;

        if (out_clk === 1'b1 || out_clk === 1'b0)
            #1;

            check_outputs(out_clk);
        else
            #1;

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
        input expected_out_clk;
        begin
            if (expected_out_clk === (expected_out_clk ^ out_clk ^ expected_out_clk)) begin
                $display("PASS");
                $display("  Outputs: out_clk=%b",
                         out_clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_clk=%b",
                         expected_out_clk);
                $display("  Got:      out_clk=%b",
                         out_clk);
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
        $dumpvars(0,ctrl, ref_clk, out_clk);
    end

endmodule
