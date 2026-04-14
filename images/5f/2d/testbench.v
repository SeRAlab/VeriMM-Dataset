`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] BOOT_DAT;
    reg CLK;
    reg [7:0] IN_DAT;
    reg [3:0] IO_A;
    reg [3:0] IO_BE;
    reg IO_RD;
    reg IO_WR;
    reg RESET_N;
    reg [31:0] STAT_DAT;
    wire ENDRAM;
    wire [31:0] IO_Q;
    wire IO_READY;
    wire RST_N;
    wire W_OUT_REG;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BOOT_DAT(BOOT_DAT),
        .CLK(CLK),
        .IN_DAT(IN_DAT),
        .IO_A(IO_A),
        .IO_BE(IO_BE),
        .IO_RD(IO_RD),
        .IO_WR(IO_WR),
        .RESET_N(RESET_N),
        .STAT_DAT(STAT_DAT),
        .ENDRAM(ENDRAM),
        .IO_Q(IO_Q),
        .IO_READY(IO_READY),
        .RST_N(RST_N),
        .W_OUT_REG(W_OUT_REG)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        RESET_N = 0;
        IO_RD = 0;
        IO_WR = 0;
        IO_A = 4'h0;
        IO_BE = 4'h0;
        BOOT_DAT = 32'h12345678;
        STAT_DAT = 32'hA5A5A5A5;
        IN_DAT = 8'h5A;
        #20;
        RESET_N = 1;
        @(posedge CLK);
        #2;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %03d: System Reset and Idle State", test_num);
        reset_dut();

        #1;


        check_outputs(1'b0, 32'h0, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %03d: Read BOOT_DAT (Addr 0)", test_num);
        reset_dut();
        IO_A = 4'h0;
        IO_BE = 4'hF;
        IO_RD = 1;
        @(posedge CLK);
        #2;

        #1;


        check_outputs(1'b0, 32'h12345678, 1'b1, 1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %03d: Read STAT_DAT (Addr 1)", test_num);
        reset_dut();
        IO_A = 4'h1;
        IO_BE = 4'hF;
        IO_RD = 1;
        @(posedge CLK);
        #2;

        #1;


        check_outputs(1'b0, 32'hA5A5A5A5, 1'b1, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %03d: Read IN_DAT (Addr 2)", test_num);
        reset_dut();
        IO_A = 4'h2;
        IO_BE = 4'h1;
        IO_RD = 1;
        @(posedge CLK);
        #2;

        #1;


        check_outputs(1'b0, {24'h0, 8'h5A}, 1'b1, 1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %03d: Write Strobe (Addr 3)", test_num);
        reset_dut();
        IO_A = 4'h3;
        IO_WR = 1;
        @(posedge CLK);
        #2;

        #1;


        check_outputs(1'b0, 32'h0, 1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %03d: ENDRAM logic (Addr 4)", test_num);
        reset_dut();
        IO_A = 4'h4;
        IO_WR = 1;
        @(posedge CLK);
        #2;

        #1;


        check_outputs(1'b1, 32'h0, 1'b1, 1'b1, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %03d: Timing stability during multi-cycle read", test_num);
        reset_dut();
        IO_A = 4'h0;
        IO_RD = 1;
        repeat(3) @(posedge CLK);
        #2;
        #1;

        check_outputs(1'b0, 32'h12345678, 1'b1, 1'b1, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTestcase %03d: Reset Propagation Check", test_num);
        reset_dut();
        RESET_N = 0;
        #1;

        #1;


        check_outputs(1'b0, 32'h0, 1'b0, 1'b0, 1'b0);
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
        input expected_ENDRAM;
        input [31:0] expected_IO_Q;
        input expected_IO_READY;
        input expected_RST_N;
        input expected_W_OUT_REG;
        begin
            if (expected_ENDRAM === (expected_ENDRAM ^ ENDRAM ^ expected_ENDRAM) &&
                expected_IO_Q === (expected_IO_Q ^ IO_Q ^ expected_IO_Q) &&
                expected_IO_READY === (expected_IO_READY ^ IO_READY ^ expected_IO_READY) &&
                expected_RST_N === (expected_RST_N ^ RST_N ^ expected_RST_N) &&
                expected_W_OUT_REG === (expected_W_OUT_REG ^ W_OUT_REG ^ expected_W_OUT_REG)) begin
                $display("PASS");
                $display("  Outputs: ENDRAM=%b, IO_Q=%h, IO_READY=%b, RST_N=%b, W_OUT_REG=%b",
                         ENDRAM, IO_Q, IO_READY, RST_N, W_OUT_REG);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ENDRAM=%b, IO_Q=%h, IO_READY=%b, RST_N=%b, W_OUT_REG=%b",
                         expected_ENDRAM, expected_IO_Q, expected_IO_READY, expected_RST_N, expected_W_OUT_REG);
                $display("  Got:      ENDRAM=%b, IO_Q=%h, IO_READY=%b, RST_N=%b, W_OUT_REG=%b",
                         ENDRAM, IO_Q, IO_READY, RST_N, W_OUT_REG);
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
        $dumpvars(0,BOOT_DAT, CLK, IN_DAT, IO_A, IO_BE, IO_RD, IO_WR, RESET_N, STAT_DAT, ENDRAM, IO_Q, IO_READY, RST_N, W_OUT_REG);
    end

endmodule
