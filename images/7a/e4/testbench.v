`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [8:0] addr_in;
    reg clk;
    reg rst_n;
    wire [8:0] addr_out;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_in(addr_in),
        .clk(clk),
        .rst_n(rst_n),
        .addr_out(addr_out),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            addr_in = 0;
            @(posedge clk);
            #1;
            rst_n = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying Reset State (Outputs should be 0)", test_num);

            rst_n = 0;
            addr_in = 9'h1FF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(9'h000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Read from Address 0x00A", test_num);
            reset_dut();
            addr_in = 9'h00A;
            @(posedge clk);
            #1;

            #1;


            check_outputs(9'h00A, data_out);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Read from Address 0x1FF", test_num);
            reset_dut();
            addr_in = 9'h1FF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(9'h1FF, data_out);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Read from Address 0x000", test_num);
            reset_dut();
            addr_in = 9'h000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(9'h000, data_out);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Reset Priority during operation", test_num);
            reset_dut();

            addr_in = 9'h055;
            @(posedge clk);
            #1;

            rst_n = 0;
            addr_in = 9'h0AA;
            @(posedge clk);
            #1;

            #1;


            check_outputs(9'h000, 16'h0000);
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
        input [8:0] expected_addr_out;
        input [15:0] expected_data_out;
        begin
            if (expected_addr_out === (expected_addr_out ^ addr_out ^ expected_addr_out) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: addr_out=%h, data_out=%h",
                         addr_out, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addr_out=%h, data_out=%h",
                         expected_addr_out, expected_data_out);
                $display("  Got:      addr_out=%h, data_out=%h",
                         addr_out, data_out);
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
        $dumpvars(0,addr_in, clk, rst_n, addr_out, data_out);
    end

endmodule
