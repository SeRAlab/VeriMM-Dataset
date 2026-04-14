`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [14:0] address;
    reg clk;
    reg [7:0] in;
    reg write;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clk(clk),
        .in(in),
        .write(write),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            address = 0;
            in = 0;
            write = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase001: Basic write and read at address 0");
            reset_dut();
            address = 15'h0000;
            in = 8'hAA;
            write = 1;
            @(posedge clk);
            #1;
            write = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase002: Write and read at a high address");
            reset_dut();
            address = 15'h3FFF;
            in = 8'h55;
            write = 1;
            @(posedge clk);
            #1;
            write = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase003: Overwriting data at the same address");
            reset_dut();

            address = 15'h0010;
            in = 8'h11;
            write = 1;
            @(posedge clk);
            #1;

            in = 8'h22;
            @(posedge clk);
            #1;
            write = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase004: Verifying Write Enable (write=0 should not change data)");
            reset_dut();

            address = 15'h0020;
            in = 8'hBB;
            write = 1;
            @(posedge clk);
            #1;

            in = 8'hEE;
            write = 0;
            @(posedge clk);
            #1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hBB);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase005: Address independence (Writing to A doesn't affect B)");
            reset_dut();

            address = 15'h0100;
            in = 8'hA1;
            write = 1;
            @(posedge clk);
            #1;

            address = 15'h0200;
            in = 8'hB2;
            @(posedge clk);
            #1;

            address = 15'h0100;
            write = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase006: Maximum address boundary test");
            reset_dut();
            address = 15'h7FFF;
            in = 8'hFF;
            write = 1;
            @(posedge clk);
            #1;
            write = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
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
        input [7:0] expected_out;
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
        $dumpvars(0,address, clk, in, write, out);
    end

endmodule
