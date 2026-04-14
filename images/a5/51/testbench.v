`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clken;
    reg d;
    reg rst_n;
    wire strobe;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clken(clken),
        .d(d),
        .rst_n(rst_n),
        .strobe(strobe)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            clken = 0;
            d = 0;
            @(posedge clk);
            #1;
            rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Normal Data Bits", test_num);
            reset_dut();
            @(negedge clk);
            clken = 1;
            d = 0;
            repeat(7) @(negedge clk);
            #2 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase002;

        integer i;
        reg [6:0] seq;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Stuffing Sequence 0111111", test_num);
            reset_dut();
            seq = 7'b0111111;
            @(negedge clk);
            clken = 1;
            for (i = 6; i >= 0; i = i - 1) begin
                d = seq[i];
                @(negedge clk);
            end
            #2 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Strobe inhibited by clken=0", test_num);
            reset_dut();
            @(negedge clk);
            clken = 1;
            d = 0;
            repeat(3) @(negedge clk);
            clken = 0;
            d = 1;
            @(negedge clk);
            #2 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sequence 1111111 (Not stuffing)", test_num);
            reset_dut();
            @(negedge clk);
            clken = 1;
            d = 1;
            repeat(10) @(negedge clk);
            #2 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase005;

        integer i;
        reg [6:0] seq;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Recovery after stuffed bit", test_num);
            reset_dut();
            seq = 7'b0111111;
            @(negedge clk);
            clken = 1;
            for (i = 6; i >= 0; i = i - 1) begin
                d = seq[i];
                @(negedge clk);
            end

            d = 0;
            @(negedge clk);
            #2 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sequence interrupted by clken=0", test_num);
            reset_dut();
            @(negedge clk);
            clken = 1; d = 0; @(negedge clk);
            clken = 1; d = 1; @(negedge clk);
            clken = 1; d = 1; @(negedge clk);
            clken = 1; d = 1; @(negedge clk);
            clken = 1; d = 1; @(negedge clk);
            clken = 1; d = 1; @(negedge clk);
            clken = 0; d = 0; @(negedge clk);
            clken = 0; d = 1; @(negedge clk);
            clken = 1; d = 1; @(negedge clk);
            #2 #1;
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
        input expected_strobe;
        begin
            if (expected_strobe === (expected_strobe ^ strobe ^ expected_strobe)) begin
                $display("PASS");
                $display("  Outputs: strobe=%b",
                         strobe);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: strobe=%b",
                         expected_strobe);
                $display("  Got:      strobe=%b",
                         strobe);
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
        $dumpvars(0,clk, clken, d, rst_n, strobe);
    end

endmodule
