`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] PCIn;
    reg clk;
    reg [31:0] ibus;
    wire [31:0] PCOut;
    wire [31:0] ibusWire;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PCIn(PCIn),
        .clk(clk),
        .ibus(ibus),
        .PCOut(PCOut),
        .ibusWire(ibusWire)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clk = 0;
            PCIn = 32'h0;
            ibus = 32'h0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transparency Check (Clock High)", test_num);
            reset_dut();
            PCIn = 32'hA5A5A5A5;
            ibus = 32'h12345678;
            clk = 1;
            #10;
            #1;

            check_outputs(32'hA5A5A5A5, 32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Latch Hold Check (Clock Low)", test_num);
            reset_dut();

            PCIn = 32'hDEADBEEF;
            clk = 1;
            #10;

            clk = 0;
            #5;

            PCIn = 32'hCAFEBABE;
            #5;
            #1;

            check_outputs(32'hDEADBEEF, 32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: ibusWire Bypass Check", test_num);
            reset_dut();
            ibus = 32'hFFFF0000;
            clk = 0;
            #10;
            ibus = 32'h0000FFFF;
            #10;
            #1;

            check_outputs(32'h00000000, 32'h0000FFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Real-time Update Check (Clock High)", test_num);
            reset_dut();
            clk = 1;
            PCIn = 32'h11111111;
            #5;
            PCIn = 32'h22222222;
            #5;
            PCIn = 32'h33333333;
            #5;
            #1;

            check_outputs(32'h33333333, 32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Bits Set Check", test_num);
            reset_dut();
            PCIn = 32'hFFFFFFFF;
            ibus = 32'hFFFFFFFF;
            clk = 1;
            #10;
            #1;

            check_outputs(32'hFFFFFFFF, 32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential Latch Sequence", test_num);
            reset_dut();


            PCIn = 32'h00000001;
            clk = 1; #10;
            clk = 0; #10;


            PCIn = 32'h00000002;
            clk = 1; #10;
            clk = 0; #10;


            PCIn = 32'h00000003;
            #10;

            #1;


            check_outputs(32'h00000002, 32'h00000000);
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
        input [31:0] expected_PCOut;
        input [31:0] expected_ibusWire;
        begin
            if (expected_PCOut === (expected_PCOut ^ PCOut ^ expected_PCOut) &&
                expected_ibusWire === (expected_ibusWire ^ ibusWire ^ expected_ibusWire)) begin
                $display("PASS");
                $display("  Outputs: PCOut=%h, ibusWire=%h",
                         PCOut, ibusWire);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PCOut=%h, ibusWire=%h",
                         expected_PCOut, expected_ibusWire);
                $display("  Got:      PCOut=%h, ibusWire=%h",
                         PCOut, ibusWire);
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
        $dumpvars(0,PCIn, clk, ibus, PCOut, ibusWire);
    end

endmodule
