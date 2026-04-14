`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] pcpi_insn;
    reg [31:0] pcpi_rs1;
    reg [31:0] pcpi_rs2;
    reg pcpi_valid;
    reg resetn;
    wire [31:0] pcpi_rd;
    wire pcpi_ready;
    wire pcpi_wait;
    wire pcpi_wr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .pcpi_insn(pcpi_insn),
        .pcpi_rs1(pcpi_rs1),
        .pcpi_rs2(pcpi_rs2),
        .pcpi_valid(pcpi_valid),
        .resetn(resetn),
        .pcpi_rd(pcpi_rd),
        .pcpi_ready(pcpi_ready),
        .pcpi_wait(pcpi_wait),
        .pcpi_wr(pcpi_wr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        resetn = 0;
        pcpi_valid = 0;
        pcpi_insn = 0;
        pcpi_rs1 = 0;
        pcpi_rs2 = 0;
        @(posedge clk);
        #2 resetn = 1;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        $display("Testcase 001: Unsigned Division (100 / 10)");
        pcpi_insn = INST_DIVU;
        pcpi_rs1 = 32'd100;
        pcpi_rs2 = 32'd10;
        pcpi_valid = 1;
        @(posedge clk);
        while (!pcpi_ready) @(posedge clk);
        #1;

        check_outputs(32'd10, 1'b1, 1'b0, 1'b1);
        pcpi_valid = 0;
        @(posedge clk);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        $display("Testcase 002: Unsigned Remainder (100 %% 7)");
        pcpi_insn = INST_REMU;
        pcpi_rs1 = 32'd100;
        pcpi_rs2 = 32'd7;
        pcpi_valid = 1;
        @(posedge clk);
        while (!pcpi_ready) @(posedge clk);
        #1;

        check_outputs(32'd2, 1'b1, 1'b0, 1'b1);
        pcpi_valid = 0;
        @(posedge clk);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        $display("Testcase 003: Signed Division (-20 / 5)");
        pcpi_insn = INST_DIV;
        pcpi_rs1 = 32'hFFFFFFEC;
        pcpi_rs2 = 32'd5;
        pcpi_valid = 1;
        @(posedge clk);
        while (!pcpi_ready) @(posedge clk);
        #1;

        check_outputs(32'hFFFFFFFC, 1'b1, 1'b0, 1'b1);
        pcpi_valid = 0;
        @(posedge clk);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        $display("Testcase 004: Signed Remainder (-20 %% 3)");
        pcpi_insn = INST_REM;
        pcpi_rs1 = 32'hFFFFFFEC;
        pcpi_rs2 = 32'd3;
        pcpi_valid = 1;
        @(posedge clk);
        while (!pcpi_ready) @(posedge clk);
        #1;

        check_outputs(32'hFFFFFFFE, 1'b1, 1'b0, 1'b1);
        pcpi_valid = 0;
        @(posedge clk);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        $display("Testcase 005: Unsigned Division by Zero (10 / 0)");
        pcpi_insn = INST_DIVU;
        pcpi_rs1 = 32'd10;
        pcpi_rs2 = 32'd0;
        pcpi_valid = 1;
        @(posedge clk);
        while (!pcpi_ready) @(posedge clk);

        #1;


        check_outputs(32'hFFFFFFFF, 1'b1, 1'b0, 1'b1);
        pcpi_valid = 0;
        @(posedge clk);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        $display("Testcase 006: Unsigned Remainder by Zero (10 %% 0)");
        pcpi_insn = INST_REMU;
        pcpi_rs1 = 32'd10;
        pcpi_rs2 = 32'd0;
        pcpi_valid = 1;
        @(posedge clk);
        while (!pcpi_ready) @(posedge clk);

        #1;


        check_outputs(32'd10, 1'b1, 1'b0, 1'b1);
        pcpi_valid = 0;
        @(posedge clk);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        $display("Testcase 007: Signed Overflow (-2147483648 / -1)");
        pcpi_insn = INST_DIV;
        pcpi_rs1 = 32'h80000000;
        pcpi_rs2 = 32'hFFFFFFFF;
        pcpi_valid = 1;
        @(posedge clk);
        while (!pcpi_ready) @(posedge clk);

        #1;


        check_outputs(32'h80000000, 1'b1, 1'b0, 1'b1);
        pcpi_valid = 0;
        @(posedge clk);
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
        input [31:0] expected_pcpi_rd;
        input expected_pcpi_ready;
        input expected_pcpi_wait;
        input expected_pcpi_wr;
        begin
            if (expected_pcpi_rd === (expected_pcpi_rd ^ pcpi_rd ^ expected_pcpi_rd) &&
                expected_pcpi_ready === (expected_pcpi_ready ^ pcpi_ready ^ expected_pcpi_ready) &&
                expected_pcpi_wait === (expected_pcpi_wait ^ pcpi_wait ^ expected_pcpi_wait) &&
                expected_pcpi_wr === (expected_pcpi_wr ^ pcpi_wr ^ expected_pcpi_wr)) begin
                $display("PASS");
                $display("  Outputs: pcpi_rd=%h, pcpi_ready=%b, pcpi_wait=%b, pcpi_wr=%b",
                         pcpi_rd, pcpi_ready, pcpi_wait, pcpi_wr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pcpi_rd=%h, pcpi_ready=%b, pcpi_wait=%b, pcpi_wr=%b",
                         expected_pcpi_rd, expected_pcpi_ready, expected_pcpi_wait, expected_pcpi_wr);
                $display("  Got:      pcpi_rd=%h, pcpi_ready=%b, pcpi_wait=%b, pcpi_wr=%b",
                         pcpi_rd, pcpi_ready, pcpi_wait, pcpi_wr);
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
        $dumpvars(0,clk, pcpi_insn, pcpi_rs1, pcpi_rs2, pcpi_valid, resetn, pcpi_rd, pcpi_ready, pcpi_wait, pcpi_wr);
    end

endmodule
