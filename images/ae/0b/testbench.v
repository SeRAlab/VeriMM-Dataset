`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] Addr;
    reg MemRW;
    reg clk;
    reg [31:0] dataW;
    reg rst_n;
    wire [31:0] dataR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Addr(Addr),
        .MemRW(MemRW),
        .clk(clk),
        .dataW(dataW),
        .rst_n(rst_n),
        .dataR(dataR)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            Addr = 0;
            dataW = 0;
            MemRW = 0;
            #20;
            rst_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            @(posedge clk);
            Addr = 32'h0;
            dataW = 32'hDEADBEEF;
            MemRW = 1;
            @(posedge clk);
            MemRW = 0;
            Addr = 32'h0;
            @(posedge clk);
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge clk);
            Addr = 32'd128;
            dataW = 32'h12345678;
            MemRW = 1;
            @(posedge clk);
            MemRW = 0;
            Addr = 32'd128;
            @(posedge clk);
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(posedge clk);
            Addr = 32'd252;
            dataW = 32'h88776655;
            MemRW = 1;
            @(posedge clk);
            MemRW = 0;
            Addr = 32'd252;
            @(posedge clk);
            #1;

            check_outputs(32'h88776655);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            @(posedge clk);
            Addr = 32'h0;
            dataW = 32'hAAAAAAAA;
            MemRW = 1;
            @(posedge clk);

            Addr = 32'h4;
            dataW = 32'hBBBBBBBB;
            MemRW = 1;
            @(posedge clk);

            MemRW = 0;
            Addr = 32'h0;
            @(posedge clk);
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(posedge clk);
            Addr = 32'd64;
            dataW = 32'h5A5A5A5A;
            MemRW = 1;
            @(posedge clk);
            MemRW = 0;
            Addr = 32'd64;
            @(posedge clk);
            #1;

            check_outputs(32'h5A5A5A5A);
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
        input [31:0] expected_dataR;
        begin
            if (expected_dataR === (expected_dataR ^ dataR ^ expected_dataR)) begin
                $display("PASS");
                $display("  Outputs: dataR=%h",
                         dataR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataR=%h",
                         expected_dataR);
                $display("  Got:      dataR=%h",
                         dataR);
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
        $dumpvars(0,Addr, MemRW, clk, dataW, rst_n, dataR);
    end

endmodule
