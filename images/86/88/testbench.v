`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] Address;
    reg Mem_R_EN;
    reg Mem_W_EN;
    reg [31:0] St_value;
    reg clk;
    reg rst;
    wire [31:0] Mem_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Address(Address),
        .Mem_R_EN(Mem_R_EN),
        .Mem_W_EN(Mem_W_EN),
        .St_value(St_value),
        .clk(clk),
        .rst(rst),
        .Mem_out(Mem_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        Address = 0;
        Mem_W_EN = 0;
        Mem_R_EN = 0;
        St_value = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();


        Address = 32'd42;
        Mem_R_EN = 1;
        Mem_W_EN = 0;

        #5;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();


        @(negedge clk);
        Address = 32'd100;
        St_value = 32'hDEADBEEF;
        Mem_W_EN = 1;

        @(posedge clk);
        #1 Mem_W_EN = 0;


        Address = 32'd100;
        Mem_R_EN = 1;

        #5;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();


        @(negedge clk);
        Address = 32'd5;
        St_value = 32'h12345678;
        Mem_W_EN = 1;
        @(posedge clk);
        #1 Mem_W_EN = 0;


        Address = 32'd5;
        Mem_R_EN = 0;

        #5;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();

        @(negedge clk);
        Address = 32'd1023;
        St_value = 32'hFFFFFFFF;
        Mem_W_EN = 1;
        @(posedge clk);
        #1 Mem_W_EN = 0;

        Address = 32'd1023;
        Mem_R_EN = 1;

        #5;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();


        @(negedge clk);
        Address = 32'd256;
        St_value = 32'hAAAA_AAAA;
        Mem_W_EN = 1;
        @(posedge clk);


        @(negedge clk);
        St_value = 32'h5555_5555;
        @(posedge clk);
        #1 Mem_W_EN = 0;

        Address = 32'd256;
        Mem_R_EN = 1;

        #5;
        #1;

        check_outputs(32'h5555_5555);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();


        @(negedge clk);
        Address = 32'd10;
        St_value = 32'h0000_1111;
        Mem_W_EN = 1;
        @(posedge clk);


        @(negedge clk);
        Address = 32'd20;
        St_value = 32'h2222_3333;
        @(posedge clk);
        #1 Mem_W_EN = 0;


        Address = 32'd10;
        Mem_R_EN = 1;

        #5;
        #1;

        check_outputs(32'h0000_1111);
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
        input [31:0] expected_Mem_out;
        begin
            if (expected_Mem_out === (expected_Mem_out ^ Mem_out ^ expected_Mem_out)) begin
                $display("PASS");
                $display("  Outputs: Mem_out=%h",
                         Mem_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Mem_out=%h",
                         expected_Mem_out);
                $display("  Got:      Mem_out=%h",
                         Mem_out);
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
        $dumpvars(0,Address, Mem_R_EN, Mem_W_EN, St_value, clk, rst, Mem_out);
    end

endmodule
