`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] addr_b;
    reg clk;
    reg [31:0] data_b_in;
    reg [31:0] data_b_we;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_b(addr_b),
        .clk(clk),
        .data_b_in(data_b_in),
        .data_b_we(data_b_we)
    );
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Valid Trigger Address (65536)");

            addr_b = 0; data_b_in = 0; data_b_we = 0;
            @(posedge clk); #1;


            addr_b = 32'd65536;
            data_b_in = 32'h0000_0048;
            data_b_we = 32'hFFFF_FFFF;
            expected_addr = 32'd65536;

            @(posedge clk);
            #1;

            check_outputs();
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Valid Trigger Address (65536) second char");
            addr_b = 0; data_b_in = 0; data_b_we = 0;
            @(posedge clk); #1;

            addr_b = 32'd65536;
            data_b_in = 32'h0000_0069;
            data_b_we = 32'hFFFF_FFFF;
            expected_addr = 32'd65536;

            @(posedge clk);
            #1;

            check_outputs();
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Invalid Address (No print expected)");
            addr_b = 0; data_b_in = 0; data_b_we = 0;
            @(posedge clk); #1;

            addr_b = 32'd1000;
            data_b_in = 32'h0000_0021;
            data_b_we = 32'hFFFF_FFFF;
            expected_addr = 32'd1000;

            @(posedge clk);
            #1;

            check_outputs();
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Boundary Address 65535");
            addr_b = 0; data_b_in = 0; data_b_we = 0;
            @(posedge clk); #1;

            addr_b = 32'd65535;
            data_b_in = 32'h0000_003F;
            data_b_we = 32'hFFFF_FFFF;
            expected_addr = 32'd65535;

            @(posedge clk);
            #1;

            check_outputs();
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Boundary Address 65537");
            addr_b = 0; data_b_in = 0; data_b_we = 0;
            @(posedge clk); #1;

            addr_b = 32'd65537;
            data_b_in = 32'h0000_0021;
            data_b_we = 32'hFFFF_FFFF;
            expected_addr = 32'd65537;

            @(posedge clk);
            #1;

            check_outputs();
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning Testcase 006: Data Integrity (LSB only)");
            addr_b = 0; data_b_in = 0; data_b_we = 0;
            @(posedge clk); #1;

            addr_b = 32'd65536;
            data_b_in = 32'hABCD_EF41;
            data_b_we = 32'hFFFF_FFFF;
            expected_addr = 32'd65536;

            @(posedge clk);
            #1;

            check_outputs();
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
        begin
            #1; // Small delay for combinational logic to settle
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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

endmodule
