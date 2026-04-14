`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [12:0] addr_in;
    reg clk;
    wire [9:0] bank0_addr;
    wire [9:0] bank1_addr;
    wire [9:0] bank2_addr;
    wire [9:0] bank3_addr;
    wire odd;
    wire [1:0] sel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_in(addr_in),
        .clk(clk),
        .bank0_addr(bank0_addr),
        .bank1_addr(bank1_addr),
        .bank2_addr(bank2_addr),
        .bank3_addr(bank3_addr),
        .odd(odd),
        .sel(sel)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr_in = 13'h0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            addr_in = 13'h0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'h000, 10'h000, 10'h000, 10'h000, 1'b0, 2'h0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            addr_in = 13'h0001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'h001, 10'h000, 10'h000, 10'h000, 1'b0, 2'h1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            addr_in = 13'h0003;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'h001, 10'h001, 10'h001, 10'h000, 1'b0, 2'h3);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            addr_in = 13'h0004;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'h001, 10'h001, 10'h001, 10'h001, 1'b1, 2'h0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            addr_in = 13'h0402;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'h081, 10'h081, 10'h080, 10'h080, 1'b0, 2'h2);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            addr_in = 13'h1FF9;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'h000, 10'h3FF, 10'h3FF, 10'h3FF, 1'b0, 2'h1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            addr_in = 13'h0807;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'h101, 10'h101, 10'h101, 10'h101, 1'b1, 2'h3);
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
        input [9:0] expected_bank0_addr;
        input [9:0] expected_bank1_addr;
        input [9:0] expected_bank2_addr;
        input [9:0] expected_bank3_addr;
        input expected_odd;
        input [1:0] expected_sel;
        begin
            if (expected_bank0_addr === (expected_bank0_addr ^ bank0_addr ^ expected_bank0_addr) &&
                expected_bank1_addr === (expected_bank1_addr ^ bank1_addr ^ expected_bank1_addr) &&
                expected_bank2_addr === (expected_bank2_addr ^ bank2_addr ^ expected_bank2_addr) &&
                expected_bank3_addr === (expected_bank3_addr ^ bank3_addr ^ expected_bank3_addr) &&
                expected_odd === (expected_odd ^ odd ^ expected_odd) &&
                expected_sel === (expected_sel ^ sel ^ expected_sel)) begin
                $display("PASS");
                $display("  Outputs: bank0_addr=%h, bank1_addr=%h, bank2_addr=%h, bank3_addr=%h, odd=%b, sel=%h",
                         bank0_addr, bank1_addr, bank2_addr, bank3_addr, odd, sel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bank0_addr=%h, bank1_addr=%h, bank2_addr=%h, bank3_addr=%h, odd=%b, sel=%h",
                         expected_bank0_addr, expected_bank1_addr, expected_bank2_addr, expected_bank3_addr, expected_odd, expected_sel);
                $display("  Got:      bank0_addr=%h, bank1_addr=%h, bank2_addr=%h, bank3_addr=%h, odd=%b, sel=%h",
                         bank0_addr, bank1_addr, bank2_addr, bank3_addr, odd, sel);
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
        $dumpvars(0,addr_in, clk, bank0_addr, bank1_addr, bank2_addr, bank3_addr, odd, sel);
    end

endmodule
