`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in;
    wire [2:0] pos;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .pos(pos)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        in = 8'b0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();
        in = 8'b1000_0000;
        @(posedge clk);
        #1;
        $display("Test %0d: Highest priority bit (Bit 7)", test_num);
        #1;

        check_outputs(3'd7);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();
        in = 8'b0000_0001;
        @(posedge clk);
        #1;
        $display("Test %0d: Lowest priority bit (Bit 0)", test_num);
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();
        in = 8'b0000_1000;
        @(posedge clk);
        #1;
        $display("Test %0d: Middle bit (Bit 3)", test_num);
        #1;

        check_outputs(3'd3);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_dut();
        in = 8'b1000_0001;
        @(posedge clk);
        #1;
        $display("Test %0d: Priority check (Bit 7 vs Bit 0)", test_num);
        #1;

        check_outputs(3'd7);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        reset_dut();
        in = 8'b0001_1100;
        @(posedge clk);
        #1;
        $display("Test %0d: Priority check (Bit 4 vs 3 vs 2)", test_num);
        #1;

        check_outputs(3'd4);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        reset_dut();

        in = 8'b0100_0000;
        @(posedge clk);
        #1;

        in = 8'b0000_0000;
        @(posedge clk);
        #1;
        $display("Test %0d: Sticky behavior (Last active was Bit 6)", test_num);
        #1;

        check_outputs(3'd6);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        reset_dut();

        in = 8'b0000_0100;
        @(posedge clk);
        #1;

        in = 8'b0000_0000;
        @(posedge clk);
        #1;
        $display("Test %0d: Sticky behavior (Last active was Bit 2)", test_num);
        #1;

        check_outputs(3'd2);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        reset_dut();
        in = 8'b1111_1111;
        @(posedge clk);
        #1;
        $display("Test %0d: All bits active", test_num);
        #1;

        check_outputs(3'd7);
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
        input [2:0] expected_pos;
        begin
            if (expected_pos === (expected_pos ^ pos ^ expected_pos)) begin
                $display("PASS");
                $display("  Outputs: pos=%h",
                         pos);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pos=%h",
                         expected_pos);
                $display("  Got:      pos=%h",
                         pos);
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
        $dumpvars(0,clk, in, pos);
    end

endmodule
