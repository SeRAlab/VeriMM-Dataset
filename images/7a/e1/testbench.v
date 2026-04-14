`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [13:0] adr_i;
    reg clk_i;
    reg [7:0] dat_i;
    reg wr_i;
    wire [7:0] dat_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .adr_i(adr_i),
        .clk_i(clk_i),
        .dat_i(dat_i),
        .wr_i(wr_i),
        .dat_o(dat_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            adr_i = 0;
            dat_i = 0;
            wr_i = 0;
            @(posedge clk_i);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Write and Read", test_num);
            reset_dut();


            adr_i = 14'h0123;
            dat_i = 8'hA5;
            wr_i = 1;
            @(posedge clk_i);
            #1;


            wr_i = 0;
            adr_i = 14'h0123;
            @(posedge clk_i);
            #1;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary Address (Max)", test_num);
            reset_dut();


            adr_i = 14'h3FFF;
            dat_i = 8'hFF;
            wr_i = 1;
            @(posedge clk_i);
            #1;


            wr_i = 0;
            adr_i = 14'h3FFF;
            @(posedge clk_i);
            #1;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Overwrite Data", test_num);
            reset_dut();


            adr_i = 14'h0005;
            dat_i = 8'h11;
            wr_i = 1;
            @(posedge clk_i);
            #1;


            dat_i = 8'h22;
            wr_i = 1;
            @(posedge clk_i);
            #1;


            wr_i = 0;
            @(posedge clk_i);
            #1;

            #1;


            check_outputs(8'h22);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Address Independence", test_num);
            reset_dut();


            adr_i = 14'h0010;
            dat_i = 8'hAA;
            wr_i = 1;
            @(posedge clk_i);
            #1;


            adr_i = 14'h0011;
            dat_i = 8'hBB;
            wr_i = 1;
            @(posedge clk_i);
            #1;


            wr_i = 0;
            adr_i = 14'h0010;
            @(posedge clk_i);
            #1;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sequential Read/Write", test_num);
            reset_dut();


            adr_i = 14'h0; dat_i = 8'h01; wr_i = 1; @(posedge clk_i); #1;
            adr_i = 14'h1; dat_i = 8'h02; wr_i = 1; @(posedge clk_i); #1;
            adr_i = 14'h2; dat_i = 8'h03; wr_i = 1; @(posedge clk_i); #1;


            wr_i = 0;
            adr_i = 14'h1;
            @(posedge clk_i);
            #1;

            #1;


            check_outputs(8'h02);
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
        input [7:0] expected_dat_o;
        begin
            if (expected_dat_o === (expected_dat_o ^ dat_o ^ expected_dat_o)) begin
                $display("PASS");
                $display("  Outputs: dat_o=%h",
                         dat_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dat_o=%h",
                         expected_dat_o);
                $display("  Got:      dat_o=%h",
                         dat_o);
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
        $dumpvars(0,adr_i, clk_i, dat_i, wr_i, dat_o);
    end

endmodule
