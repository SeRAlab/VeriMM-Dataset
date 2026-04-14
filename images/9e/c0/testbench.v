`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire [9:0] hcnt;
    wire [9:0] vcnt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .hcnt(hcnt),
        .vcnt(vcnt)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            #20;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(10'd0, 10'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Horizontal Increment (Mid-line)", test_num);
            reset_dut();
            repeat(100) @(posedge clk);
            #1;
            #1;

            check_outputs(10'd100, 10'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Horizontal (799)", test_num);
            reset_dut();
            repeat(799) @(posedge clk);
            #1;
            #1;

            check_outputs(10'd799, 10'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Horizontal Wrap (800 cycles)", test_num);
            reset_dut();
            repeat(800) @(posedge clk);
            #1;
            #1;

            check_outputs(10'd0, 10'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multi-line Wrap (1600 cycles)", test_num);
            reset_dut();
            repeat(1600) @(posedge clk);
            #1;
            #1;

            check_outputs(10'd0, 10'd2);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mid-line Offset (850 cycles)", test_num);
            reset_dut();
            repeat(850) @(posedge clk);
            #1;
            #1;

            check_outputs(10'd50, 10'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Vertical Boundary (Line 520)", test_num);
            reset_dut();
            repeat(800 * 520) @(posedge clk);
            #1;
            #1;

            check_outputs(10'd0, 10'd520);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full Frame Wrap (800 * 521 cycles)", test_num);
            reset_dut();
            repeat(800 * 521) @(posedge clk);
            #1;
            #1;

            check_outputs(10'd0, 10'd0);
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
        testcase008();
        
        
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
        input [9:0] expected_hcnt;
        input [9:0] expected_vcnt;
        begin
            if (expected_hcnt === (expected_hcnt ^ hcnt ^ expected_hcnt) &&
                expected_vcnt === (expected_vcnt ^ vcnt ^ expected_vcnt)) begin
                $display("PASS");
                $display("  Outputs: hcnt=%h, vcnt=%h",
                         hcnt, vcnt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hcnt=%h, vcnt=%h",
                         expected_hcnt, expected_vcnt);
                $display("  Got:      hcnt=%h, vcnt=%h",
                         hcnt, vcnt);
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
        $dumpvars(0,clk, rst, hcnt, vcnt);
    end

endmodule
