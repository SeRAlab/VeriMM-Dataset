`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] in_address;
    reg pc_ce;
    wire [11:0] out_address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_address(in_address),
        .pc_ce(pc_ce),
        .out_address(out_address)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in_address = 16'h0000;
            pc_ce = 1;
            @(posedge clk);
            #1;
            pc_ce = 0;
            in_address = 16'h0000;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Capture lower 12 bits of 0x1234");
            test_num = test_num + 1;
            reset_dut();
            in_address = 16'h1234;
            pc_ce = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h234);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Capture lower 12 bits of 0xFFFF");
            test_num = test_num + 1;
            reset_dut();
            in_address = 16'hFFFF;
            pc_ce = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Verify no update when pc_ce is low");
            test_num = test_num + 1;
            reset_dut();
            in_address = 16'hABCD;
            pc_ce = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Load value and then hold while input changes");
            test_num = test_num + 1;
            reset_dut();


            in_address = 16'hA555;
            pc_ce = 1;
            @(posedge clk);
            #1;


            pc_ce = 0;
            in_address = 16'hB666;
            @(posedge clk);
            #1;

            #1;


            check_outputs(12'h555);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Consecutive updates");
            test_num = test_num + 1;
            reset_dut();

            pc_ce = 1;
            in_address = 16'h1111;
            @(posedge clk);
            #1;

            in_address = 16'h2222;
            @(posedge clk);
            #1;

            #1;


            check_outputs(12'h222);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Capture zero address");
            test_num = test_num + 1;
            reset_dut();


            in_address = 16'h0FFF;
            pc_ce = 1;
            @(posedge clk);
            #1;


            in_address = 16'hF000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(12'h000);
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
        input [11:0] expected_out_address;
        begin
            if (expected_out_address === (expected_out_address ^ out_address ^ expected_out_address)) begin
                $display("PASS");
                $display("  Outputs: out_address=%h",
                         out_address);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_address=%h",
                         expected_out_address);
                $display("  Got:      out_address=%h",
                         out_address);
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
        $dumpvars(0,clk, in_address, pc_ce, out_address);
    end

endmodule
