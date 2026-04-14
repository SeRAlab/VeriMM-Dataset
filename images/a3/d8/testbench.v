`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] ibus;
    wire [31:0] ibusWire;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ibus(ibus),
        .ibusWire(ibusWire)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ibus = 32'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Data Capture", test_num);
            reset_dut();
            ibus = 32'hDEADBEEF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All Zeros", test_num);
            reset_dut();
            ibus = 32'h00000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All Ones", test_num);
            reset_dut();
            ibus = 32'hFFFFFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Holding Data between Clock Edges", test_num);
            reset_dut();
            ibus = 32'h12345678;
            @(posedge clk);
            #2;
            ibus = 32'h87654321;
            #2;

            #1;


            check_outputs(32'h12345678);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Alternating Bits", test_num);
            reset_dut();
            ibus = 32'hAAAAAAAA;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sequential Multi-cycle Update", test_num);
            reset_dut();
            ibus = 32'h11111111;
            @(posedge clk);
            #2;
            ibus = 32'h22222222;
            @(posedge clk);
            #2;
            ibus = 32'h33333333;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h33333333);
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
        input [31:0] expected_ibusWire;
        begin
            if (expected_ibusWire === (expected_ibusWire ^ ibusWire ^ expected_ibusWire)) begin
                $display("PASS");
                $display("  Outputs: ibusWire=%h",
                         ibusWire);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ibusWire=%h",
                         expected_ibusWire);
                $display("  Got:      ibusWire=%h",
                         ibusWire);
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
        $dumpvars(0,clk, ibus, ibusWire);
    end

endmodule
