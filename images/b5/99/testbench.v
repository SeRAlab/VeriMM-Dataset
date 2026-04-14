`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] d;
    reg [31:0] dval;
    reg [31:0] pc;
    reg [5:0] s1;
    reg [5:0] s2;
    reg we;
    wire [31:0] s1val;
    wire [31:0] s2val;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .dval(dval),
        .pc(pc),
        .s1(s1),
        .s2(s2),
        .we(we),
        .s1val(s1val),
        .s2val(s2val)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        we = 0;
        d = 0;
        dval = 0;
        pc = 0;
        s1 = 0;
        s2 = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        pc = 32'hA5A5A5A5;
        s1 = 6'd0;
        s2 = 6'd32;
        #1;
        #1;

        check_outputs(32'h0, 32'hA5A5A5A5);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        we = 1;
        d = 5'd1;
        dval = 32'h12345678;
        @(posedge clk);
        #1;
        we = 0;
        s1 = 6'd1;
        s2 = 6'd0;
        #1;
        #1;

        check_outputs(32'h12345678, 32'h0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        we = 1;
        d = 5'd0;
        dval = 32'hFFFFFFFF;
        @(posedge clk);
        #1;
        we = 0;
        s1 = 6'd0;
        s2 = 6'd0;
        #1;
        #1;

        check_outputs(32'h0, 32'h0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        pc = 32'h11112222;
        s1 = 6'd32;
        #1;
        pc = 32'h33334444;
        #1;
        s2 = 6'd32;
        #1;
        #1;

        check_outputs(32'h33334444, 32'h33334444);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;

        we = 1; d = 5'd10; dval = 32'hAAAA_BBBB;
        @(posedge clk);

        d = 5'd20; dval = 32'hCCCC_DDDD;
        @(posedge clk);
        #1;
        we = 0;
        s1 = 6'd10;
        s2 = 6'd20;
        #1;
        #1;

        check_outputs(32'hAAAA_BBBB, 32'hCCCC_DDDD);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        we = 0;
        d = 5'd15;
        dval = 32'h5555_6666;
        @(posedge clk);
        #1;
        s1 = 6'd15;
        s2 = 6'd0;
        #1;

        if (s1val == 32'h5555_6666) begin
            $display("FAIL: Test %0d - Write occurred while we=0", test_num);
            fail_count = fail_count + 1;
        end else begin
            $display("PASS: Test %0d - Write inhibited as expected", test_num);
            pass_count = pass_count + 1;
        end
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
        input [31:0] expected_s1val;
        input [31:0] expected_s2val;
        begin
            if (expected_s1val === (expected_s1val ^ s1val ^ expected_s1val) &&
                expected_s2val === (expected_s2val ^ s2val ^ expected_s2val)) begin
                $display("PASS");
                $display("  Outputs: s1val=%h, s2val=%h",
                         s1val, s2val);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: s1val=%h, s2val=%h",
                         expected_s1val, expected_s2val);
                $display("  Got:      s1val=%h, s2val=%h",
                         s1val, s2val);
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
        $dumpvars(0,clk, d, dval, pc, s1, s2, we, s1val, s2val);
    end

endmodule
