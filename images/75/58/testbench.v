`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] in1;
    reg [31:0] in2;
    reg rst;
    reg sel;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in1(in1),
        .in2(in2),
        .rst(rst),
        .sel(sel),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(posedge clk);
        rst <= 1;
        in1 <= 0;
        in2 <= 0;
        sel <= 0;
        @(posedge clk);
        #1 rst <= 0;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Checking Synchronous Reset", test_num);


        @(posedge clk);
        rst <= 1;
        in1 <= 32'hFFFFFFFF;
        in2 <= 32'hAAAAAAAA;
        sel <= 1;

        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Select in1 (sel=1)", test_num);

        @(posedge clk);
        in1 <= 32'hDEADBEEF;
        in2 <= 32'hCAFEBABE;
        sel <= 1;

        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Select in2 (sel=0)", test_num);

        @(posedge clk);
        in1 <= 32'h12345678;
        in2 <= 32'h87654321;
        sel <= 0;

        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h87654321);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Dynamic Switching (in2 -> in1)", test_num);

        @(posedge clk);
        in1 <= 32'hAAAA5555;
        in2 <= 32'h5555AAAA;
        sel <= 0;

        @(posedge clk);
        sel <= 1;

        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hAAAA5555);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Reset priority over active inputs", test_num);

        @(posedge clk);
        in1 <= 32'h11112222;
        in2 <= 32'h33334444;
        sel <= 1;

        @(posedge clk);
        rst <= 1;

        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h00000000);
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
        input [31:0] expected_out;
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
        $dumpvars(0,clk, in1, in2, rst, sel, out);
    end

endmodule
