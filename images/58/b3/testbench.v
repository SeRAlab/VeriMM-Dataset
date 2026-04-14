`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [7:0] address;
    wire [7:0] out_ascii;
    wire [7:0] out_bin_lsb;
    wire [7:0] out_bin_msb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .address(address),
        .out_ascii(out_ascii),
        .out_bin_lsb(out_bin_lsb),
        .out_bin_msb(out_bin_msb)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            #1 reset = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Checking Reset State");
            reset_dut();

            #1;


            check_outputs(8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Checking First Increment (ASCII '0')");
            reset_dut();
            @(posedge clk);
            #1;





            #1;






            check_outputs(8'h01, 8'h30, 8'h0C, 8'h30);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Checking Second Increment (ASCII '1')");
            reset_dut();
            @(posedge clk);
            @(posedge clk);
            #1;





            #1;






            check_outputs(8'h02, 8'h31, 8'h8C, 8'h31);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Checking Fifth Increment (ASCII '4')");
            reset_dut();
            repeat(5) @(posedge clk);
            #1;





            #1;






            check_outputs(8'h05, 8'h34, 8'h2C, 8'h34);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Checking Mid-range ASCII");
            reset_dut();


            repeat(18) @(posedge clk);
            #1;


            #1;



            check_outputs(8'd18, 8'h41, 8'h82, 8'h41);
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
        input [7:0] expected_address;
        input [7:0] expected_out_ascii;
        input [7:0] expected_out_bin_lsb;
        input [7:0] expected_out_bin_msb;
        begin
            if (expected_address === (expected_address ^ address ^ expected_address) &&
                expected_out_ascii === (expected_out_ascii ^ out_ascii ^ expected_out_ascii) &&
                expected_out_bin_lsb === (expected_out_bin_lsb ^ out_bin_lsb ^ expected_out_bin_lsb) &&
                expected_out_bin_msb === (expected_out_bin_msb ^ out_bin_msb ^ expected_out_bin_msb)) begin
                $display("PASS");
                $display("  Outputs: address=%h, out_ascii=%h, out_bin_lsb=%h, out_bin_msb=%h",
                         address, out_ascii, out_bin_lsb, out_bin_msb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: address=%h, out_ascii=%h, out_bin_lsb=%h, out_bin_msb=%h",
                         expected_address, expected_out_ascii, expected_out_bin_lsb, expected_out_bin_msb);
                $display("  Got:      address=%h, out_ascii=%h, out_bin_lsb=%h, out_bin_msb=%h",
                         address, out_ascii, out_bin_lsb, out_bin_msb);
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
        $dumpvars(0,clk, reset, address, out_ascii, out_bin_lsb, out_bin_msb);
    end

endmodule
