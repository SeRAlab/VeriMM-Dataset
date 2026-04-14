`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg READ_EN;
    reg WRITE_EN;
    reg [15:0] addr;
    reg clk;
    reg [15:0] in;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .READ_EN(READ_EN),
        .WRITE_EN(WRITE_EN),
        .addr(addr),
        .clk(clk),
        .in(in),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            READ_EN = 0;
            WRITE_EN = 0;
            addr = 0;
            in = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Basic Write/Read at Addr 0");


            @(negedge clk);
            WRITE_EN = 1;
            addr = 16'h0000;
            in = 16'hABCD;

            @(negedge clk);
            WRITE_EN = 0;


            READ_EN = 1;
            addr = 16'h0000;
            #2;

            #1;


            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Write/Read at Upper Bound Addr 4095");

            @(negedge clk);
            WRITE_EN = 1;
            addr = 16'd4095;
            in = 16'h55AA;

            @(negedge clk);
            WRITE_EN = 0;

            READ_EN = 1;
            addr = 16'd4095;
            #2;

            #1;


            check_outputs(16'h55AA);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Overwriting Data");


            @(negedge clk);
            WRITE_EN = 1; addr = 16'h0010; in = 16'h1111;
            @(negedge clk);


            in = 16'h2222;
            @(negedge clk);
            WRITE_EN = 0;

            READ_EN = 1;
            addr = 16'h0010;
            #2;

            #1;


            check_outputs(16'h2222);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Verify WRITE_EN = 0 prevents writing");


            @(negedge clk);
            WRITE_EN = 0;
            addr = 16'h0020;
            in = 16'hDEAD;

            @(negedge clk);


            READ_EN = 1;
            addr = 16'h0020;
            #2;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Sequential Access to multiple addresses");


            @(negedge clk);
            WRITE_EN = 1; addr = 16'h0001; in = 16'hAAAA;
            @(negedge clk);

            addr = 16'h0002; in = 16'hBBBB;
            @(negedge clk);
            WRITE_EN = 0;


            READ_EN = 1; addr = 16'h0001;
            #2;

            addr = 16'h0002;
            #2;

            #1;


            check_outputs(16'hBBBB);
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
        input [15:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,READ_EN, WRITE_EN, addr, clk, in, out);
    end

endmodule
