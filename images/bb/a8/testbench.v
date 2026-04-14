`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [10:0] addrread;
    reg [10:0] addrwrite;
    reg clk;
    reg [8:0] din;
    reg we;
    wire [8:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addrread(addrread),
        .addrwrite(addrwrite),
        .clk(clk),
        .din(din),
        .we(we),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        addrread <= 0;
        addrwrite <= 0;
        we <= 0;
        din <= 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;


        addrwrite <= 11'h00A;
        din <= 9'h1AA;
        we <= 1;
        @(posedge clk);
        #1;


        we <= 0;
        addrread <= 11'h00A;
        @(posedge clk);
        #1;

        $display("Testcase 001: Basic Write and Read back");
        #1;

        check_outputs(9'h1AA);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;


        addrwrite <= 11'h7FF;
        din <= 9'h0FF;
        we <= 1;
        @(posedge clk);
        #1;


        we <= 0;
        addrread <= 11'h7FF;
        @(posedge clk);
        #1;

        $display("Testcase 002: Boundary Address 2047 Check");
        #1;

        check_outputs(9'h0FF);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;


        addrwrite <= 11'h064;
        din <= 9'h055;
        we <= 1;
        @(posedge clk);
        #1;


        addrwrite <= 11'h064;
        din <= 9'h0AA;
        we <= 0;
        @(posedge clk);
        #1;


        addrread <= 11'h064;
        @(posedge clk);
        #1;

        $display("Testcase 003: Write Enable (WE) Disable Check");

        #1;


        check_outputs(9'h055);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;


        addrwrite <= 11'h014;
        din <= 9'h123;
        we <= 1;
        @(posedge clk);
        #1;


        addrwrite <= 11'h01E;
        din <= 9'h1FF;
        we <= 1;
        addrread <= 11'h014;
        @(posedge clk);
        #1;

        $display("Testcase 004: Simultaneous Read/Write Different Addresses");
        #1;

        check_outputs(9'h123);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;


        addrwrite <= 11'h032;
        din <= 9'h010;
        we <= 1;
        @(posedge clk);
        #1;




        addrwrite <= 11'h032;
        din <= 9'h020;
        we <= 1;
        addrread <= 11'h032;
        @(posedge clk);
        #1;

        $display("Testcase 005: Simultaneous Read/Write Same Address");
        #1;

        check_outputs(9'h010);
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
        input [8:0] expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
        $dumpvars(0,addrread, addrwrite, clk, din, we, dout);
    end

endmodule
