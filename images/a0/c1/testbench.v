`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [14:0] address;
    reg clk;
    reg [7:0] in;
    reg reset;
    reg write;
    wire [7:0] out;
    wire [7:0] testWire;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clk(clk),
        .in(in),
        .reset(reset),
        .write(write),
        .out(out),
        .testWire(testWire)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            address = 0;
            in = 0;
            write = 0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset State Check", test_num);
            reset_dut();
            address = 15'h0005;
            write = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simple Write and Read", test_num);
            reset_dut();


            address = 15'h0010;
            in = 8'hA5;
            write = 1;
            @(posedge clk);
            #2;


            write = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hA5, 8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple Address Access", test_num);
            reset_dut();


            address = 15'h0020;
            in = 8'h11;
            write = 1;
            @(posedge clk);
            #2;


            address = 15'h0021;
            in = 8'h22;
            write = 1;
            @(posedge clk);
            #2;


            write = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h22, 8'h22);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Data Overwrite", test_num);
            reset_dut();


            address = 15'h0030;
            in = 8'hCC;
            write = 1;
            @(posedge clk);
            #2;


            in = 8'hDD;
            write = 1;
            @(posedge clk);
            #2;


            write = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hDD, 8'hDD);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write Enable Check", test_num);
            reset_dut();


            address = 15'h0040;
            in = 8'h55;
            write = 1;
            @(posedge clk);
            #2;


            in = 8'hFF;
            write = 0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(8'h55, 8'h55);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: High Address Boundary", test_num);
            reset_dut();


            address = 15'h7FFF;
            in = 8'h99;
            write = 1;
            @(posedge clk);
            #2;

            write = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h99, 8'h99);
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
        input [7:0] expected_testWire;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_testWire === (expected_testWire ^ testWire ^ expected_testWire)) begin
                $display("PASS");
                $display("  Outputs: out=%h, testWire=%h",
                         out, testWire);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, testWire=%h",
                         expected_out, expected_testWire);
                $display("  Got:      out=%h, testWire=%h",
                         out, testWire);
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
        $dumpvars(0,address, clk, in, reset, write, out, testWire);
    end

endmodule
