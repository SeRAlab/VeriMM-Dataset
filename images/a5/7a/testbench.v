`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] PcSource;
    reg clk;
    reg [31:0] in0;
    reg [31:0] in1;
    reg [31:0] in2;
    reg rst;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PcSource(PcSource),
        .clk(clk),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .rst(rst),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: PcSource 00 (Select in0)", test_num);

        rst = 1; @(posedge clk); #1 rst = 0;

        in0 = 32'hAAAAAAAA; in1 = 32'h0; in2 = 32'h0; PcSource = 2'b00;
        @(posedge clk);
        #1;

        check_outputs(32'hAAAAAAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: PcSource 01 (Select in1)", test_num);

        rst = 1; @(posedge clk); #1 rst = 0;

        in0 = 32'h0; in1 = 32'h55555555; in2 = 32'h0; PcSource = 2'b01;
        @(posedge clk);
        #1;

        check_outputs(32'h55555555);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: PcSource 10 (Select in2)", test_num);

        rst = 1; @(posedge clk); #1 rst = 0;

        in0 = 32'h0; in1 = 32'h0; in2 = 32'h12345678; PcSource = 2'b10;
        @(posedge clk);
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: PcSource 11 (Constant Zero)", test_num);

        rst = 1; @(posedge clk); #1 rst = 0;

        in0 = 32'hFFFFFFFF; in1 = 32'hFFFFFFFF; in2 = 32'hFFFFFFFF; PcSource = 2'b11;
        @(posedge clk);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Reset Override Check", test_num);

        rst = 0; in0 = 32'hDEADBEEF; PcSource = 2'b00;
        @(posedge clk);

        rst = 1;
        @(posedge clk);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Data switching stability", test_num);

        rst = 1; @(posedge clk); #1 rst = 0;

        in2 = 32'hCAFEFACE; PcSource = 2'b10;
        @(posedge clk);

        in2 = 32'hBADC0DE1;
        @(posedge clk);
        #1;

        check_outputs(32'hBADC0DE1);
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
        input [31:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
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

endmodule
