`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg [15:0] mem_addr;
    wire [15:0] addr;
    wire [15:0] data_out;
    wire en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .mem_addr(mem_addr),
        .addr(addr),
        .data_out(data_out),
        .en(en)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            mem_addr <= 16'h0;
            data_in <= 16'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Valid Address - Middle of range", test_num);
            mem_addr <= 16'h1050;
            data_in  <= 16'hABCD;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0050, 16'hABCD, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Valid Address - Boundary (Start)", test_num);
            mem_addr <= 16'h1000;
            data_in  <= 16'h1234;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0000, 16'h1234, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Invalid Address - Below Range", test_num);
            mem_addr <= 16'h0FFF;
            data_in  <= 16'h5555;
            @(posedge clk);
            #1;

            #1;


            check_outputs(addr, 16'h0000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Invalid Address - Above Range", test_num);
            mem_addr <= 16'hF000;
            data_in  <= 16'hAAAA;
            @(posedge clk);
            #1;

            #1;


            check_outputs(addr, 16'h0000, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Valid Address - High Data Value", test_num);
            mem_addr <= 16'h1100;
            data_in  <= 16'hFFFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0100, 16'hFFFF, 1'b1);
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
        input [15:0] expected_addr;
        input [15:0] expected_data_out;
        input expected_en;
        begin
            if (expected_addr === (expected_addr ^ addr ^ expected_addr) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_en === (expected_en ^ en ^ expected_en)) begin
                $display("PASS");
                $display("  Outputs: addr=%h, data_out=%h, en=%b",
                         addr, data_out, en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addr=%h, data_out=%h, en=%b",
                         expected_addr, expected_data_out, expected_en);
                $display("  Got:      addr=%h, data_out=%h, en=%b",
                         addr, data_out, en);
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
        $dumpvars(0,clk, data_in, mem_addr, addr, data_out, en);
    end

endmodule
