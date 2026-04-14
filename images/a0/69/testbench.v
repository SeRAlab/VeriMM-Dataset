`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load_incr;
    reg reset;
    reg [4:0] upc_next;
    wire [4:0] upc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .load_incr(load_incr),
        .reset(reset),
        .upc_next(upc_next),
        .upc(upc)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        load_incr = 0;
        upc_next = 5'b0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase001: Basic Reset Verification");
        reset_dut();




        #1;





        check_outputs(5'd1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase002: Incremental Counting (0 -> 5)");
        reset_dut();
        load_incr = 0;
        repeat (4) @(posedge clk);
        #1;
        #1;

        check_outputs(5'd5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase003: Load Functionality");
        reset_dut();
        load_incr = 1;
        upc_next = 5'd25;
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'd25);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase004: Wrap-around (31 -> 0)");
        reset_dut();
        load_incr = 1;
        upc_next = 5'd31;
        @(posedge clk);
        #1;
        load_incr = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase005: Reset Priority Over Load");
        reset_dut();
        load_incr = 1;
        upc_next = 5'd10;
        reset = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'd0);
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
        input [4:0] expected_upc;
        begin
            if (expected_upc === (expected_upc ^ upc ^ expected_upc)) begin
                $display("PASS");
                $display("  Outputs: upc=%h",
                         upc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: upc=%h",
                         expected_upc);
                $display("  Got:      upc=%h",
                         upc);
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
        $dumpvars(0,clk, load_incr, reset, upc_next, upc);
    end

endmodule
