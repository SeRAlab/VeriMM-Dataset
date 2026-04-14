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
            BusW = 0;
            RA = 0;
            RB = 0;
            RW = 0;

            @(posedge Clk);
            @(negedge Clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: Basic Write/Read R1 and R2", test_num);


            @(posedge Clk);
            RegWr = 1; RW = 1; BusW = 32'hDEADBEEF;
            @(negedge Clk);


            @(posedge Clk);
            RegWr = 1; RW = 2; BusW = 32'hCAFEBABE;
            @(negedge Clk);


            @(posedge Clk);
            RegWr = 0; RA = 1; RB = 2;
            #1;
            #1;

            check_outputs(32'hDEADBEEF, 32'hCAFEBABE);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Register 0 Write/Read Logic", test_num);

            @(posedge Clk);
            RegWr = 1; RW = 0; BusW = 32'hFFFFFFFF;
            @(negedge Clk);

            @(posedge Clk);
            RegWr = 0; RA = 0; RB = 0;
            #1;
            #1;

            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: 'Otherwise' Clear Logic (RegWr=0 clears Reg[RW])", test_num);


            @(posedge Clk);
            RegWr = 1; RW = 5; BusW = 32'h12345678;
            @(negedge Clk);


            @(posedge Clk);
            RegWr = 0; RW = 5;
            @(negedge Clk);


            @(posedge Clk);
            RA = 5; RB = 5;
            #1;
            #1;

            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Boundary Register R31 and Simultaneous Read", test_num);


            @(posedge Clk);
            RegWr = 1; RW = 31; BusW = 32'hAAAA5555;
            @(negedge Clk);


            @(posedge Clk);
            RegWr = 1; RW = 10; BusW = 32'h00001111;
            @(negedge Clk);

            @(posedge Clk);
            RegWr = 0; RA = 31; RB = 10;
            #1;
            #1;

            check_outputs(32'hAAAA5555, 32'h00001111);
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
