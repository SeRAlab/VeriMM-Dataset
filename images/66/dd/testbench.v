`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] addr;
    reg clk;
    reg cs;
    reg [31:0] data_in;
    reg re;
    reg reset;
    reg we;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .cs(cs),
        .data_in(data_in),
        .re(re),
        .reset(reset),
        .we(we),
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
        cs = 0;
        we = 0;
        re = 0;
        addr = 0;
        data_in = 0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Basic Write and Read", test_num);
        reset_dut();


        addr = 16'hA001;
        data_in = 32'h12345678;
        cs = 1;
        we = 1;
        re = 0;
        @(posedge clk);
        #1;


        we = 0;
        re = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h12345678);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Reset Clear functionality", test_num);
        reset_dut();


        addr = 16'hB002;
        data_in = 32'hFFFFFFFF;
        cs = 1; we = 1; re = 0;
        @(posedge clk);
        #1;


        reset = 1;
        @(posedge clk);
        #1;
        reset = 0;


        we = 0; re = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h00000000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Chip Select (cs) Inactive", test_num);
        reset_dut();


        addr = 16'hC003;
        data_in = 32'hDEADBEEF;
        cs = 0;
        we = 1;
        @(posedge clk);
        #1;


        cs = 1;
        we = 0;
        re = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h00000000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Multiple addresses", test_num);
        reset_dut();


        addr = 16'h0001; data_in = 32'hAAAA_AAAA; cs = 1; we = 1; re = 0;
        @(posedge clk); #1;


        addr = 16'h0002; data_in = 32'h5555_5555;
        @(posedge clk); #1;


        addr = 16'h0001; we = 0; re = 1;
        @(posedge clk); #1;



        addr = 16'h0002;
        @(posedge clk); #1;

        #1;


        check_outputs(32'h5555_5555);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Write Enable (we) Inactive", test_num);
        reset_dut();


        addr = 16'hD005; data_in = 32'h1111_2222; cs = 1; we = 1;
        @(posedge clk); #1;


        data_in = 32'h9999_9999; we = 0;
        @(posedge clk); #1;


        re = 1;
        @(posedge clk); #1;

        #1;


        check_outputs(32'h1111_2222);
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
        input [31:0] expected_data_out;
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
        $dumpvars(0,addr, clk, cs, data_in, re, reset, we, data_out);
    end

endmodule
