`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg enable;
    reg reset;
    wire [3:0] data_out;
    wire overflow;
    wire parity;
    wire underflow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .reset(reset),
        .data_out(data_out),
        .overflow(overflow),
        .parity(parity),
        .underflow(underflow)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            data_in = 0;
            @(posedge clk);
            #1 reset = 0;

            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic accumulation and parity toggle...");
            test_num = 1;
            reset_dut();

            data_in = 4'h5;
            enable = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'h5, 0, 1, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Multiple cycles accumulation...");
            test_num = 2;
            reset_dut();

            data_in = 4'h2;
            enable = 1;
            @(posedge clk);
            #1;

            data_in = 4'h3;
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'h5, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Overflow detection...");
            test_num = 3;
            reset_dut();

            data_in = 4'hA;
            enable = 1;
            @(posedge clk);
            #1;

            data_in = 4'h7;
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'h1, 1, 0, 0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Enable signal control...");
            test_num = 4;
            reset_dut();

            data_in = 4'h4;
            enable = 1;
            @(posedge clk);
            #1;

            enable = 0;
            data_in = 4'h8;
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'h4, 0, 1, 0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Recovery from overflow...");
            test_num = 5;
            reset_dut();

            data_in = 4'hF;
            enable = 1;
            @(posedge clk);
            #1;

            data_in = 4'h2;
            @(posedge clk);
            #1;

            data_in = 4'h1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'h2, 0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Mid-operation reset...");
            test_num = 6;
            reset_dut();

            data_in = 4'h8;
            enable = 1;
            @(posedge clk);
            #1;

            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;


            #1;



            check_outputs(4'h0, 0, 0, 0);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Boundary maximum (15)...");
            test_num = 7;
            reset_dut();

            data_in = 4'h8;
            enable = 1;
            @(posedge clk);
            #1;

            data_in = 4'h7;
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'hF, 0, 0, 0);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Underflow boundary check...");
            test_num = 8;
            reset_dut();

            data_in = 4'h0;
            enable = 1;
            @(posedge clk);
            #1;



            #1;




            check_outputs(4'h0, 0, 1, 0);
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
        testcase008();
        
        
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
        input [3:0] expected_data_out;
        input expected_overflow;
        input expected_parity;
        input expected_underflow;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_parity === (expected_parity ^ parity ^ expected_parity) &&
                expected_underflow === (expected_underflow ^ underflow ^ expected_underflow)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, overflow=%b, parity=%b, underflow=%b",
                         data_out, overflow, parity, underflow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, overflow=%b, parity=%b, underflow=%b",
                         expected_data_out, expected_overflow, expected_parity, expected_underflow);
                $display("  Got:      data_out=%h, overflow=%b, parity=%b, underflow=%b",
                         data_out, overflow, parity, underflow);
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
        $dumpvars(0,clk, data_in, enable, reset, data_out, overflow, parity, underflow);
    end

endmodule
