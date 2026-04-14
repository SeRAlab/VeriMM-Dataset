`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] addr;
    reg clk;
    reg rd;
    reg [31:0] wdata;
    reg wr;
    wire [31:0] rdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .rd(rd),
        .wdata(wdata),
        .wr(wr),
        .rdata(rdata)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr = 0;
            rd = 0;
            wr = 0;
            wdata = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Write to address 10 and read it back");


            addr = 10;
            wdata = 32'hDEADBEEF;
            wr = 1;
            rd = 0;
            @(posedge clk);
            #1;
            wr = 0;


            rd = 1;
            addr = 10;
            #2;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Check if rdata follows wdata when rd=0");

            rd = 0;
            wdata = 32'h12345678;
            #2;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Write to multiple addresses and verify no corruption");


            addr = 5; wdata = 32'hAAAA_5555; wr = 1; @(posedge clk); #1;

            addr = 6; wdata = 32'hCCCC_3333; wr = 1; @(posedge clk); #1;

            wr = 0;

            rd = 1; addr = 5; #2;
            #1;

            check_outputs(32'hAAAA_5555);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Write/Read address 0");

            addr = 0;
            wdata = 32'h87654321;
            wr = 1;
            @(posedge clk);
            #1;
            wr = 0;
            rd = 1;
            #2;
            #1;

            check_outputs(32'h87654321);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Write/Read address 63 (64th word)");

            addr = 63;
            wdata = 32'hABCDEF01;
            wr = 1;
            @(posedge clk);
            #1;
            wr = 0;
            rd = 1;
            #2;
            #1;

            check_outputs(32'hABCDEF01);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase 006: Overwriting data at the same address");


            addr = 20; wdata = 32'h1111_1111; wr = 1; @(posedge clk); #1;

            addr = 20; wdata = 32'h2222_2222; wr = 1; @(posedge clk); #1;

            wr = 0;
            rd = 1;
            addr = 20;
            #2;
            #1;

            check_outputs(32'h2222_2222);
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
        input [31:0] expected_rdata;
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
        $dumpvars(0,addr, clk, rd, wdata, wr, rdata);
    end

endmodule
