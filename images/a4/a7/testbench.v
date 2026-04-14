`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg [31:0] in;
    reg reset;
    wire final_output;
    wire [2:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .in(in),
        .reset(reset),
        .final_output(final_output),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        d = 0;
        in = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();

        #1;


        check_outputs(1'b0, 3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        d = 1; @(posedge clk);
        d = 1; @(posedge clk);
        d = 1; @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 3'b111);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        d = 1; @(posedge clk);
        d = 0; @(posedge clk);
        d = 1; @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 3'b101);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        in = 32'h0000_0001; @(posedge clk);
        in = 32'h0000_0000; @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 3'b000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        in = 32'h8000_0000; @(posedge clk);
        in = 32'h0000_0000; @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 3'b000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        in = 32'h0000_0003; @(posedge clk);
        in = 32'h0000_0000; @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 3'b000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        in = 32'h0000_0007; @(posedge clk);
        in = 32'h0000_0000; @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 3'b000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset_dut();
        in = 32'hFFFF_FFFF; @(posedge clk);
        in = 32'h0000_0000; @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 3'b000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        reset_dut();
        in = 32'h0000_0000; @(posedge clk);
        in = 32'hFFFF_FFFF; @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 3'b000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        reset_dut();
        in = 32'h0000_0001; d = 1; @(posedge clk);
        in = 32'h0000_0000; d = 1; @(posedge clk);
        d = 1; @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 3'b111);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        reset_dut();
        in = 32'h1; @(posedge clk);
        in = 32'h0; @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 3'b000);
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
        testcase009();
        testcase010();
        testcase011();
        
        
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
        input expected_final_output;
        input [2:0] expected_q;
        begin
            if (expected_final_output === (expected_final_output ^ final_output ^ expected_final_output) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: final_output=%b, q=%h",
                         final_output, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: final_output=%b, q=%h",
                         expected_final_output, expected_q);
                $display("  Got:      final_output=%b, q=%h",
                         final_output, q);
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
        $dumpvars(0,clk, d, in, reset, final_output, q);
    end

endmodule
