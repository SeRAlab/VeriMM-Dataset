`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [10:0] raddr;
    reg [10:0] waddr;
    reg [7:0] wdata;
    reg we;
    wire [7:0] rdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .raddr(raddr),
        .waddr(waddr),
        .wdata(wdata),
        .we(we),
        .rdata(rdata)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            waddr = 0;
            wdata = 0;
            raddr = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Basic Write and Read");


            we = 1;
            waddr = 11'h010;
            wdata = 8'hA5;
            @(posedge clk);
            #1;
            we = 0;


            raddr = 11'h010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Multiple writes, specific read");


            we = 1; waddr = 11'h001; wdata = 8'h11; @(posedge clk); #1;

            we = 1; waddr = 11'h002; wdata = 8'h22; @(posedge clk); #1;

            we = 1; waddr = 11'h003; wdata = 8'h33; @(posedge clk); #1;
            we = 0;


            raddr = 11'h002;
            @(posedge clk); #1;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Write Enable (we=0) check");


            we = 1; waddr = 11'h050; wdata = 8'hFF; @(posedge clk); #1;


            we = 0; waddr = 11'h050; wdata = 8'h00; @(posedge clk); #1;


            raddr = 11'h050;
            @(posedge clk); #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Overwrite location");

            we = 1; waddr = 11'h100; wdata = 8'hAA; @(posedge clk); #1;
            we = 1; waddr = 11'h100; wdata = 8'h55; @(posedge clk); #1;
            we = 0;

            raddr = 11'h100;
            @(posedge clk); #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Max address boundary check (0x7FF)");

            we = 1; waddr = 11'h7FF; wdata = 8'hDB; @(posedge clk); #1;
            we = 0;

            raddr = 11'h7FF;
            @(posedge clk); #1;
            #1;

            check_outputs(8'hDB);
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
        input [7:0] expected_rdata;
        begin
            if (expected_rdata === (expected_rdata ^ rdata ^ expected_rdata)) begin
                $display("PASS");
                $display("  Outputs: rdata=%h",
                         rdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rdata=%h",
                         expected_rdata);
                $display("  Got:      rdata=%h",
                         rdata);
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
        $dumpvars(0,clk, raddr, waddr, wdata, we, rdata);
    end

endmodule
