`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [22:0] address_in;
    reg clk;
    reg [15:0] data_in;
    reg rd;
    reg reset;
    reg sel_akiko;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address_in(address_in),
        .clk(clk),
        .data_in(data_in),
        .rd(rd),
        .reset(reset),
        .sel_akiko(sel_akiko),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        address_in = 0;
        data_in = 0;
        rd = 0;
        sel_akiko = 0;
        @(posedge clk);
        #2 reset = 0;
        @(posedge clk);
        #2;
    end
        endtask
    task write_word;

        input [15:0] data;
        begin
            address_in = 23'h5C001C;
            sel_akiko = 1;
            rd = 0;
            data_in = data;
            @(posedge clk);
            #2;
            sel_akiko = 0;
            @(posedge clk);
            #2;
        end
        endtask

    task read_word;

        begin
            address_in = 23'h5C001C;
            sel_akiko = 1;
            rd = 1;
            @(posedge clk);
            #2;
        end
        endtask

    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Basic single word write/read", test_num);
        reset_dut();
        write_word(16'hA5A5);
        read_word();
        #1;

        check_outputs(16'hA5A5);
    end
        endtask

    task testcase002;

    integer i;
    begin
        test_num = 2;
        $display("Testcase %03d: Fill 128-bit register and read back last word", test_num);
        reset_dut();
        for (i = 0; i < 8; i = i + 1) begin
            write_word(16'h1000 + i);
        end

        for (i = 0; i < 8; i = i + 1) begin
            read_word();
        end

        #1;


        check_outputs(16'h1007);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Address mismatch prevents write", test_num);
        reset_dut();
        address_in = 23'h5C001D;
        sel_akiko = 1;
        rd = 0;
        data_in = 16'hDEAD;
        @(posedge clk);
        #2;

        read_word();
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: sel_akiko low prevents read", test_num);
        reset_dut();
        write_word(16'hBEEF);

        address_in = 23'h5C001C;
        sel_akiko = 0;
        rd = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: rd signal low defaults output to zero", test_num);
        reset_dut();
        write_word(16'hCAFE);

        address_in = 23'h5C001C;
        sel_akiko = 1;
        rd = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(16'h0000);
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
        input [15:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,address_in, clk, data_in, rd, reset, sel_akiko, data_out);
    end

endmodule
