`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] BusW;
    reg Clk;
    reg [4:0] RA;
    reg [4:0] RB;
    reg [4:0] RW;
    reg RegWr;
    wire [31:0] BusA;
    wire [31:0] BusB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BusW(BusW),
        .Clk(Clk),
        .RA(RA),
        .RB(RB),
        .RW(RW),
        .RegWr(RegWr),
        .BusA(BusA),
        .BusB(BusB)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            RegWr = 0;
            RW = 0;
            RA = 0;
            RB = 0;
            BusW = 0;
            @(posedge Clk);
            @(negedge Clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            @(negedge Clk);
            RegWr = 1;
            RW = 1;
            BusW = 32'hFFFFFFFF;
            @(negedge Clk);
            RegWr = 0;
            RA = 1;
            RB = 0;
            @(posedge Clk);
            #1;

            check_outputs(32'h7FFFFFFF, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(negedge Clk);
            RegWr = 1;
            RW = 31;
            BusW = 32'h12345678;
            @(negedge Clk);
            RegWr = 0;
            RA = 31;
            RB = 0;
            @(posedge Clk);
            #1;

            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(negedge Clk);
            RegWr = 0;
            RW = 5;
            BusW = 32'hAAAAAAAA;
            @(negedge Clk);
            RA = 5;
            RB = 0;
            @(posedge Clk);
            #1;

            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            @(negedge Clk);
            RegWr = 1; RW = 10; BusW = 32'h00001111;
            @(negedge Clk);

            RW = 20; BusW = 32'h00002222;
            @(negedge Clk);
            RegWr = 0;
            RA = 10;
            RB = 20;
            @(posedge Clk);
            #1;

            check_outputs(32'h00001111, 32'h00002222);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(negedge Clk);
            RegWr = 1;
            RW = 2;
            BusW = 32'h80000001;
            @(negedge Clk);
            RegWr = 0;
            RA = 2;
            RB = 2;
            @(posedge Clk);
            #1;

            check_outputs(32'h00000001, 32'h00000001);
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
        input [31:0] expected_BusA;
        input [31:0] expected_BusB;
        begin
            if (expected_BusA === (expected_BusA ^ BusA ^ expected_BusA) &&
                expected_BusB === (expected_BusB ^ BusB ^ expected_BusB)) begin
                $display("PASS");
                $display("  Outputs: BusA=%h, BusB=%h",
                         BusA, BusB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BusA=%h, BusB=%h",
                         expected_BusA, expected_BusB);
                $display("  Got:      BusA=%h, BusB=%h",
                         BusA, BusB);
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
        $dumpvars(0,BusW, Clk, RA, RB, RW, RegWr, BusA, BusB);
    end

endmodule
