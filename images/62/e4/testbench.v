`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg INST_MUL;
    reg INST_MULH;
    reg INST_MULHSU;
    reg INST_MULHU;
    reg [31:0] RS1;
    reg [31:0] RS2;
    reg RST_N;
    wire [31:0] RD;
    wire READY;
    wire WAIT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .INST_MUL(INST_MUL),
        .INST_MULH(INST_MULH),
        .INST_MULHSU(INST_MULHSU),
        .INST_MULHU(INST_MULHU),
        .RS1(RS1),
        .RS2(RS2),
        .RST_N(RST_N),
        .RD(RD),
        .READY(READY),
        .WAIT(WAIT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST_N = 0;
            INST_MUL = 0;
            INST_MULH = 0;
            INST_MULHSU = 0;
            INST_MULHU = 0;
            RS1 = 0;
            RS2 = 0;
            repeat(2) @(posedge CLK);
            #1 RST_N = 1;
            repeat(2) @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test %0d: MUL (1234 * 5678)", test_num);
            RS1 = 32'd1234;
            RS2 = 32'd5678;
            INST_MUL = 1;
            @(posedge CLK);
            INST_MUL = 0;

            while (!READY) @(posedge CLK);
            #1;

            check_outputs(32'h006AE93C, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test %0d: MUL (-1 * 5)", test_num);
            RS1 = 32'hFFFFFFFF;
            RS2 = 32'd5;
            INST_MUL = 1;
            @(posedge CLK);
            INST_MUL = 0;
            while (!READY) @(posedge CLK);
            #1;

            check_outputs(32'hFFFFFFF7, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test %0d: MULH (MaxInt * MaxInt)", test_num);
            RS1 = 32'h7FFFFFFF;
            RS2 = 32'h7FFFFFFF;
            INST_MULH = 1;
            @(posedge CLK);
            INST_MULH = 0;
            while (!READY) @(posedge CLK);

            #1;


            check_outputs(32'h3FFFFFFF, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test %0d: MULH (MinInt * 2)", test_num);
            RS1 = 32'h80000000;
            RS2 = 32'd2;
            INST_MULH = 1;
            @(posedge CLK);
            INST_MULH = 0;
            while (!READY) @(posedge CLK);

            #1;


            check_outputs(32'hFFFFFFFF, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test %0d: MULHU (MaxUint * MaxUint)", test_num);
            RS1 = 32'hFFFFFFFF;
            RS2 = 32'hFFFFFFFF;
            INST_MULHU = 1;
            @(posedge CLK);
            INST_MULHU = 0;
            while (!READY) @(posedge CLK);

            #1;


            check_outputs(32'hFFFFFFFE, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test %0d: MULHSU (-1 * 1)", test_num);
            RS1 = 32'hFFFFFFFF;
            RS2 = 32'h00000001;
            INST_MULHSU = 1;
            @(posedge CLK);
            INST_MULHSU = 0;
            while (!READY) @(posedge CLK);

            #1;


            check_outputs(32'hFFFFFFFF, 1'b1, 1'b0);
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
        input [31:0] expected_RD;
        input expected_READY;
        input expected_WAIT;
        begin
            if (expected_RD === (expected_RD ^ RD ^ expected_RD) &&
                expected_READY === (expected_READY ^ READY ^ expected_READY) &&
                expected_WAIT === (expected_WAIT ^ WAIT ^ expected_WAIT)) begin
                $display("PASS");
                $display("  Outputs: RD=%h, READY=%b, WAIT=%b",
                         RD, READY, WAIT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RD=%h, READY=%b, WAIT=%b",
                         expected_RD, expected_READY, expected_WAIT);
                $display("  Got:      RD=%h, READY=%b, WAIT=%b",
                         RD, READY, WAIT);
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
        $dumpvars(0,CLK, INST_MUL, INST_MULH, INST_MULHSU, INST_MULHU, RS1, RS2, RST_N, RD, READY, WAIT);
    end

endmodule
