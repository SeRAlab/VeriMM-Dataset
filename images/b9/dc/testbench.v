`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg IFID_write;
    reg [31:0] address_i;
    reg clk_i;
    reg [31:0] instr_i;
    reg rst_i;
    wire [31:0] address_o;
    wire [31:0] instr_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IFID_write(IFID_write),
        .address_i(address_i),
        .clk_i(clk_i),
        .instr_i(instr_i),
        .rst_i(rst_i),
        .address_o(address_o),
        .instr_o(instr_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            rst_i = 0;
            IFID_write = 0;
            address_i = 32'h0;
            instr_i = 32'h0;
            @(posedge clk_i);
            #1;
            rst_i = 1;
            @(posedge clk_i);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Reset Check");
            reset_dut();


            #1;



            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Successful Write Operation");
            reset_dut();
            IFID_write = 1;
            address_i = 32'h0000_1000;
            instr_i = 32'hEF00_1234;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(32'h0000_1000, 32'hEF00_1234);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Write Enable Inhibited (Stall)");
            reset_dut();


            IFID_write = 1;
            address_i = 32'hAAAA_BBBB;
            instr_i = 32'h1111_2222;
            @(posedge clk_i);
            #1;


            IFID_write = 0;
            address_i = 32'hCCCC_DDDD;
            instr_i = 32'h3333_4444;
            @(posedge clk_i);
            #1;


            #1;



            check_outputs(32'hAAAA_BBBB, 32'h1111_2222);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Consecutive Writes");
            reset_dut();

            IFID_write = 1;

            address_i = 32'h0000_0004;
            instr_i = 32'h0011_0011;
            @(posedge clk_i);
            #1;

            address_i = 32'h0000_0008;
            instr_i = 32'h0022_0022;
            @(posedge clk_i);
            #1;

            #1;


            check_outputs(32'h0000_0008, 32'h0022_0022);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Positive Edge Trigger Verification");
            reset_dut();

            IFID_write = 1;
            address_i = 32'h1234_5678;
            instr_i = 32'h9ABC_DEF0;

            @(negedge clk_i);
            #1;

            if (address_o === 32'h0 && instr_o === 32'h0) begin

                @(posedge clk_i);
                #1;
                #1;

                check_outputs(32'h1234_5678, 32'h9ABC_DEF0);
            end else begin
                $display("FAIL: Data captured on falling edge or incorrectly");
                fail_count = fail_count + 1;
            end
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
        input [31:0] expected_address_o;
        input [31:0] expected_instr_o;
        begin
            if (expected_address_o === (expected_address_o ^ address_o ^ expected_address_o) &&
                expected_instr_o === (expected_instr_o ^ instr_o ^ expected_instr_o)) begin
                $display("PASS");
                $display("  Outputs: address_o=%h, instr_o=%h",
                         address_o, instr_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: address_o=%h, instr_o=%h",
                         expected_address_o, expected_instr_o);
                $display("  Got:      address_o=%h, instr_o=%h",
                         address_o, instr_o);
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
        $dumpvars(0,IFID_write, address_i, clk_i, instr_i, rst_i, address_o, instr_o);
    end

endmodule
