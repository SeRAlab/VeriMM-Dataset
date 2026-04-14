`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] addr;
    reg clk;
    reg [15:0] data_in;
    reg rst;
    reg wr_en;
    wire [15:0] data_out;
    wire [15:0] test_data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .wr_en(wr_en),
        .data_out(data_out),
        .test_data_out(test_data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            wr_en = 0;
            addr = 0;
            data_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Initial State Check", test_num);
            reset_dut();
            addr = 16'h0000;
            #2;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Write to Address 0", test_num);
            reset_dut();
            addr = 16'h0000;
            data_in = 16'hABCD;
            wr_en = 1;
            @(posedge clk);
            #1 wr_en = 0;
            #2;
            #1;

            check_outputs(16'hABCD, 16'hABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Write to Address 10", test_num);
            reset_dut();


            addr = 16'h0000;
            data_in = 16'h1111;
            wr_en = 1;
            @(posedge clk);


            addr = 16'h000A;
            data_in = 16'h55AA;
            wr_en = 1;
            @(posedge clk);
            #1 wr_en = 0;
            #2;
            #1;

            check_outputs(16'h55AA, 16'h1111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Address Wrapping Check (Addr 64 maps to 0)", test_num);
            reset_dut();

            addr = 16'h0040;
            data_in = 16'hFACE;
            wr_en = 1;
            @(posedge clk);
            #1 wr_en = 0;
            #2;

            #1;


            check_outputs(16'hFACE, 16'hFACE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Boundary Address 63 Check", test_num);
            reset_dut();

            addr = 16'h003F;
            data_in = 16'hE00E;
            wr_en = 1;
            @(posedge clk);
            #1 wr_en = 0;
            #2;
            #1;

            check_outputs(16'hE00E, 16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Data Overwrite Check", test_num);
            reset_dut();

            addr = 16'h0005;
            data_in = 16'h1234;
            wr_en = 1;
            @(posedge clk);

            data_in = 16'h5678;
            @(posedge clk);
            #1 wr_en = 0;
            #2;
            #1;

            check_outputs(16'h5678, 16'h0000);
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
        input [15:0] expected_data_out;
        input [15:0] expected_test_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_test_data_out === (expected_test_data_out ^ test_data_out ^ expected_test_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, test_data_out=%h",
                         data_out, test_data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, test_data_out=%h",
                         expected_data_out, expected_test_data_out);
                $display("  Got:      data_out=%h, test_data_out=%h",
                         data_out, test_data_out);
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
        $dumpvars(0,addr, clk, data_in, rst, wr_en, data_out, test_data_out);
    end

endmodule
