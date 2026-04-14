`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg RegWrite;
    reg clk;
    reg nrst;
    reg [4:0] rreg1;
    reg [4:0] rreg2;
    reg [4:0] wra;
    reg [31:0] wrd;
    wire [31:0] rd1;
    wire [31:0] rd2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .RegWrite(RegWrite),
        .clk(clk),
        .nrst(nrst),
        .rreg1(rreg1),
        .rreg2(rreg2),
        .wra(wra),
        .wrd(wrd),
        .rd1(rd1),
        .rd2(rd2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            nrst = 0;
            RegWrite = 0;
            rreg1 = 0;
            rreg2 = 0;
            wra = 0;
            wrd = 0;
            @(posedge clk);
            #1;
            nrst = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial state after reset", test_num);
            reset_dut();
            rreg1 = 5;
            rreg2 = 31;
            #1;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single register write and read rd1", test_num);
            reset_dut();
            RegWrite = 1;
            wra = 1;
            wrd = 32'hDEADBEEF;
            @(posedge clk);
            #1;
            RegWrite = 0;
            rreg1 = 1;
            rreg2 = 0;
            #1;
            #1;

            check_outputs(32'hDEADBEEF, 32'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Simultaneous dual read", test_num);
            reset_dut();

            RegWrite = 1; wra = 10; wrd = 32'h12345678;
            @(posedge clk); #1;

            RegWrite = 1; wra = 20; wrd = 32'h87654321;
            @(posedge clk); #1;
            RegWrite = 0;
            rreg1 = 10;
            rreg2 = 20;
            #1;
            #1;

            check_outputs(32'h12345678, 32'h87654321);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Write Enable (RegWrite) control", test_num);
            reset_dut();

            RegWrite = 0;
            wra = 15;
            wrd = 32'hFFFFFFFF;
            @(posedge clk); #1;
            rreg1 = 15;
            #1;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Overwrite register data", test_num);
            reset_dut();
            RegWrite = 1; wra = 7; wrd = 32'h1;
            @(posedge clk); #1;
            RegWrite = 1; wra = 7; wrd = 32'h2;
            @(posedge clk); #1;
            RegWrite = 0; rreg1 = 7;
            #1;
            #1;

            check_outputs(32'h2, 32'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Boundary register 31 access", test_num);
            reset_dut();
            RegWrite = 1; wra = 31; wrd = 32'hAAAAAAAA;
            @(posedge clk); #1;
            rreg1 = 31;
            #1;
            #1;

            check_outputs(32'hAAAAAAAA, 32'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Register 0 behavior", test_num);
            reset_dut();
            RegWrite = 1; wra = 0; wrd = 32'h55555555;
            @(posedge clk); #1;
            rreg1 = 0;
            #1;

            #1;


            check_outputs(32'h55555555, 32'h0);
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
        input [31:0] expected_rd1;
        input [31:0] expected_rd2;
        begin
            if (expected_rd1 === (expected_rd1 ^ rd1 ^ expected_rd1) &&
                expected_rd2 === (expected_rd2 ^ rd2 ^ expected_rd2)) begin
                $display("PASS");
                $display("  Outputs: rd1=%h, rd2=%h",
                         rd1, rd2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd1=%h, rd2=%h",
                         expected_rd1, expected_rd2);
                $display("  Got:      rd1=%h, rd2=%h",
                         rd1, rd2);
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
        $dumpvars(0,RegWrite, clk, nrst, rreg1, rreg2, wra, wrd, rd1, rd2);
    end

endmodule
