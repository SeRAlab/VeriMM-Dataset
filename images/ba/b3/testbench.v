`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg full;
    reg rst_n;
    reg wr_en;
    wire [2:0] wr_addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .full(full),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .wr_addr(wr_addr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            full = 0;
            wr_en = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset verification", test_num);
            reset_dut();

            #1;


            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic increment (1 cycle)", test_num);
            reset_dut();
            wr_en = 1;
            full = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple increments (5 cycles)", test_num);
            reset_dut();
            wr_en = 1;
            full = 0;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(3'b101);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Full signal blockage", test_num);
            reset_dut();
            wr_en = 1;
            full = 1;
            repeat(3) @(posedge clk);
            #1 #1;
 check_outputs(3'b000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: wr_en low blockage", test_num);
            reset_dut();
            wr_en = 0;
            full = 0;
            repeat(3) @(posedge clk);
            #1 #1;
 check_outputs(3'b000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Wrap-around (8 increments)", test_num);
            reset_dut();
            wr_en = 1;
            full = 0;
            repeat(8) @(posedge clk);
            #1 #1;
 check_outputs(3'b000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Intermittent wr_en", test_num);
            reset_dut();
            full = 0;

            wr_en = 1; @(posedge clk);
            wr_en = 0; @(posedge clk);
            wr_en = 1; @(posedge clk);
            wr_en = 0; @(posedge clk);
            wr_en = 1; @(posedge clk);

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
        input [2:0] expected_wr_addr;
        begin
            if (expected_wr_addr === (expected_wr_addr ^ wr_addr ^ expected_wr_addr)) begin
                $display("PASS");
                $display("  Outputs: wr_addr=%h",
                         wr_addr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: wr_addr=%h",
                         expected_wr_addr);
                $display("  Got:      wr_addr=%h",
                         wr_addr);
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
        $dumpvars(0,clk, full, rst_n, wr_en, wr_addr);
    end

endmodule
