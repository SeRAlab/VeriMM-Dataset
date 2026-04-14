`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg oe;
    reg [31:0] padin;
    wire [31:0] padout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .oe(oe),
        .padin(padin),
        .padout(padout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            oe = 1;
            padin = 32'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Direct Output (oe=1)", test_num);
            padin = 32'hA5A5_B6B6;
            oe = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hA5A5_B6B6);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Padding Sequence Cycle 1 (oe=0)", test_num);
            padin = 32'h1234_5678;
            oe = 1;
            @(posedge clk);
            #1;
            oe = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Padding Sequence Cycle 2 (Padded Zeros)", test_num);
            padin = 32'hDEAD_BEEF;
            oe = 1;
            @(posedge clk);
            #1;
            oe = 0;
            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Data Isolation during Padding", test_num);
            padin = 32'h1111_2222;
            oe = 1;
            @(posedge clk);
            #1;
            oe = 0;
            padin = 32'hFFFF_FFFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h1111_2222);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: OE Re-assertion Recovery", test_num);
            padin = 32'h8888_9999;
            oe = 1;
            @(posedge clk);
            #1;
            oe = 0;
            @(posedge clk);
            @(posedge clk);
            #1;
            oe = 1;
            padin = 32'hCAFE_BABE;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hCAFE_BABE);
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
        input [31:0] expected_padout;
        begin
            if (expected_padout === (expected_padout ^ padout ^ expected_padout)) begin
                $display("PASS");
                $display("  Outputs: padout=%h",
                         padout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: padout=%h",
                         expected_padout);
                $display("  Got:      padout=%h",
                         padout);
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
        $dumpvars(0,clk, oe, padin, padout);
    end

endmodule
