`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] mar_next;
    reg mar_we;
    wire [31:0] mar;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .mar_next(mar_next),
        .mar_we(mar_we),
        .mar(mar)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            mar_we = 1;
            mar_next = 32'h0;
            @(posedge clk);
            #1;
            mar_we = 0;
            mar_next = 32'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Write...");
            reset_dut();
            test_num = 1;
            mar_we = 1;
            mar_next = 32'h12345678;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Write Enable Disable...");
            reset_dut();
            test_num = 2;


            mar_we = 1;
            mar_next = 32'hAAAA_BBBB;
            @(posedge clk);
            #1;


            mar_we = 0;
            mar_next = 32'hFFFF_FFFF;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'hAAAA_BBBB);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: All Bits Set...");
            reset_dut();
            test_num = 3;
            mar_we = 1;
            mar_next = 32'hFFFF_FFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Sequential Writes...");
            reset_dut();
            test_num = 4;

            mar_we = 1;
            mar_next = 32'h5555_5555;
            @(posedge clk);
            #1;

            mar_next = 32'hCCCC_3333;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hCCCC_3333);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Write Zeros...");
            reset_dut();
            test_num = 5;


            mar_we = 1;
            mar_next = 32'hDEADC0DE;
            @(posedge clk);
            #1;


            mar_next = 32'h0000_0000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0000_0000);
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
        input [31:0] expected_mar;
        begin
            if (expected_mar === (expected_mar ^ mar ^ expected_mar)) begin
                $display("PASS");
                $display("  Outputs: mar=%h",
                         mar);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mar=%h",
                         expected_mar);
                $display("  Got:      mar=%h",
                         mar);
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
        $dumpvars(0,clk, mar_next, mar_we, mar);
    end

endmodule
