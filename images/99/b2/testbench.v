`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg read;
    reg sdram_rst;
    reg sys_clk;
    reg tim_cas;
    reg [1:0] tim_wr;
    reg write;
    wire precharge_safe;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .read(read),
        .sdram_rst(sdram_rst),
        .sys_clk(sys_clk),
        .tim_cas(tim_cas),
        .tim_wr(tim_wr),
        .write(write),
        .precharge_safe(precharge_safe)
    );

    // Clock generation (10ns period)
    initial begin
        sys_clk = 0;
        forever #5 sys_clk = ~sys_clk;
    end

        task reset_dut;

        begin
            sdram_rst = 1;
            read = 0;
            write = 0;
            tim_cas = 0;
            tim_wr = 0;
            repeat(2) @(posedge sys_clk);
            #1 sdram_rst = 0;
            @(posedge sys_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge sys_clk);
            #1 read = 1;
            tim_cas = 1;
            @(posedge sys_clk);
            #1 read = 0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(posedge sys_clk);
            #1 read = 1;
            tim_cas = 0;
            @(posedge sys_clk);
            #1 read = 0;
            repeat(10) @(posedge sys_clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(posedge sys_clk);
            #1 write = 1;
            tim_wr = 2'b10;
            @(posedge sys_clk);
            #1 write = 0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(posedge sys_clk);
            #1 write = 1;
            tim_wr = 2'b11;
            @(posedge sys_clk);
            #1 write = 0;
            repeat(12) @(posedge sys_clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            @(posedge sys_clk);
            #1 read = 1;
            @(posedge sys_clk);
            #1 read = 0;
            write = 1;
            @(posedge sys_clk);
            #1 write = 0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            @(posedge sys_clk);
            #1 read = 1;
            @(posedge sys_clk);
            #1 read = 0;
            write = 1;
            @(posedge sys_clk);
            #1 write = 0;
            repeat(15) @(posedge sys_clk);
            #1;
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
        input expected_precharge_safe;
        begin
            if (expected_precharge_safe === (expected_precharge_safe ^ precharge_safe ^ expected_precharge_safe)) begin
                $display("PASS");
                $display("  Outputs: precharge_safe=%b",
                         precharge_safe);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: precharge_safe=%b",
                         expected_precharge_safe);
                $display("  Got:      precharge_safe=%b",
                         precharge_safe);
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
        $dumpvars(0,read, sdram_rst, sys_clk, tim_cas, tim_wr, write, precharge_safe);
    end

endmodule
