`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] addr;
    reg clk;
    reg [31:0] wd;
    reg we;
    wire [31:0] rd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .wd(wd),
        .we(we),
        .rd(rd)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            addr = 32'b0;
            wd = 32'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            we = 1;
            addr = 32'h0000_0000;
            wd = 32'hDEADBEEF;
            @(posedge clk);
            #1;
            we = 0;
            addr = 32'h0000_0000;
            #1;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            we = 1;
            addr = 32'h0000_0010;
            wd = 32'hCAFEBABE;
            @(posedge clk);
            #1;
            we = 0;
            addr = 32'h0000_0010;
            #1;
            #1;

            check_outputs(32'hCAFEBABE);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;

            we = 1;
            addr = 32'h0000_0020;
            wd = 32'h12345678;
            @(posedge clk);
            #1;

            we = 0;
            wd = 32'h87654321;
            @(posedge clk);
            #1;
            addr = 32'h0000_0020;
            #1;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            we = 1;
            addr = 32'h0000_00FC;
            wd = 32'hAAAA_5555;
            @(posedge clk);
            #1;
            we = 0;
            addr = 32'h0000_00FC;
            #1;
            #1;

            check_outputs(32'hAAAA_5555);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;

            we = 1;
            addr = 32'h0000_0004;
            wd = 32'h0000_0001;
            @(posedge clk);
            #1;

            wd = 32'hFFFF_FFFF;
            @(posedge clk);
            #1;
            we = 0;
            addr = 32'h0000_0004;
            #1;
            #1;

            check_outputs(32'hFFFF_FFFF);
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
        input [31:0] expected_rd;
        begin
            if (expected_rd === (expected_rd ^ rd ^ expected_rd)) begin
                $display("PASS");
                $display("  Outputs: rd=%h",
                         rd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd=%h",
                         expected_rd);
                $display("  Got:      rd=%h",
                         rd);
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
        $dumpvars(0,addr, clk, wd, we, rd);
    end

endmodule
