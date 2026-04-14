`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] addr;
    reg mclk28;
    reg reset_in;
    reg we;
    wire bank1;
    wire card_ram_rd;
    wire card_ram_we;
    wire [17:0] ram_addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .mclk28(mclk28),
        .reset_in(reset_in),
        .we(we),
        .bank1(bank1),
        .card_ram_rd(card_ram_rd),
        .card_ram_we(card_ram_we),
        .ram_addr(ram_addr)
    );

    // Clock generation (10ns period)
    initial begin
        mclk28 = 0;
        forever #5 mclk28 = ~mclk28;
    end

        task reset_dut;

        begin
            @(posedge mclk28);
            reset_in = 1;
            addr = 16'h0;
            we = 0;
            @(posedge mclk28);
            #1;
            reset_in = 0;
            @(posedge mclk28);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            addr = 16'h1234;
            we = 1;
            @(posedge mclk28);
            #2;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 18'h01234);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            addr = 16'h4321;
            we = 0;
            @(posedge mclk28);
            #2;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 18'h04321);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            addr = 16'h8001;
            we = 1;
            @(posedge mclk28);
            #2;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 18'h08001);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            addr = 16'hFFFF;
            we = 0;
            @(posedge mclk28);
            #2;

            #1;


            check_outputs(1'b1, 1'b1, 1'b0, 18'h0FFFF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            addr = 16'h7FFF;
            we = 1;
            @(posedge mclk28);
            #2;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 18'h07FFF);
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
        input expected_bank1;
        input expected_card_ram_rd;
        input expected_card_ram_we;
        input [17:0] expected_ram_addr;
        begin
            if (expected_bank1 === (expected_bank1 ^ bank1 ^ expected_bank1) &&
                expected_card_ram_rd === (expected_card_ram_rd ^ card_ram_rd ^ expected_card_ram_rd) &&
                expected_card_ram_we === (expected_card_ram_we ^ card_ram_we ^ expected_card_ram_we) &&
                expected_ram_addr === (expected_ram_addr ^ ram_addr ^ expected_ram_addr)) begin
                $display("PASS");
                $display("  Outputs: bank1=%b, card_ram_rd=%b, card_ram_we=%b, ram_addr=%h",
                         bank1, card_ram_rd, card_ram_we, ram_addr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bank1=%b, card_ram_rd=%b, card_ram_we=%b, ram_addr=%h",
                         expected_bank1, expected_card_ram_rd, expected_card_ram_we, expected_ram_addr);
                $display("  Got:      bank1=%b, card_ram_rd=%b, card_ram_we=%b, ram_addr=%h",
                         bank1, card_ram_rd, card_ram_we, ram_addr);
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
        $dumpvars(0,addr, mclk28, reset_in, we, bank1, card_ram_rd, card_ram_we, ram_addr);
    end

endmodule
