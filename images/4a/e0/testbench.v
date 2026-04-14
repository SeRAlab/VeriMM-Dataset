`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg [31:0] MemAddr;
    reg Reset;
    wire [31:0] MemDataOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .MemAddr(MemAddr),
        .Reset(Reset),
        .MemDataOut(MemDataOut)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            Reset = 1;
            MemAddr = 0;
            @(posedge Clk);
            #2;
            Reset = 0;
            @(posedge Clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %03d: Reading Address 0x00000000", test_num);
            reset_dut();
            MemAddr = 32'h00000000;
            @(posedge Clk);
            #2;


            #1;



            check_outputs(dut.mem[0]);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %03d: Reading Address 0x00000004", test_num);
            reset_dut();
            MemAddr = 32'h00000004;
            @(posedge Clk);
            #2;

            #1;


            check_outputs(dut.mem[1]);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %03d: Reading Address 0x00000008", test_num);
            reset_dut();
            MemAddr = 32'h00000008;
            @(posedge Clk);
            #2;
            #1;

            check_outputs(dut.mem[2]);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %03d: Reading Address 0x0000001C (Address 28)", test_num);
            reset_dut();
            MemAddr = 32'h0000001C;
            @(posedge Clk);
            #2;
            #1;

            check_outputs(dut.mem[7]);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %03d: Stability check at Address 0x0000000C", test_num);
            reset_dut();
            MemAddr = 32'h0000000C;
            repeat(3) @(posedge Clk);
            #2;
            #1;

            check_outputs(dut.mem[3]);
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
        input [31:0] expected_MemDataOut;
        begin
            if (expected_MemDataOut === (expected_MemDataOut ^ MemDataOut ^ expected_MemDataOut)) begin
                $display("PASS");
                $display("  Outputs: MemDataOut=%h",
                         MemDataOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MemDataOut=%h",
                         expected_MemDataOut);
                $display("  Got:      MemDataOut=%h",
                         MemDataOut);
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
        $dumpvars(0,Clk, MemAddr, Reset, MemDataOut);
    end

endmodule
