`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clrn;
    reg [31:0] ealu;
    reg [31:0] eb;
    reg em2reg;
    reg [4:0] ern;
    reg ewmem;
    reg ewreg;
    wire [31:0] malu;
    wire [31:0] mb;
    wire mm2reg;
    wire [4:0] mrn;
    wire mwmem;
    wire mwreg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clrn(clrn),
        .ealu(ealu),
        .eb(eb),
        .em2reg(em2reg),
        .ern(ern),
        .ewmem(ewmem),
        .ewreg(ewreg),
        .malu(malu),
        .mb(mb),
        .mm2reg(mm2reg),
        .mrn(mrn),
        .mwmem(mwmem),
        .mwreg(mwreg)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clrn = 0;
            ealu = 32'h0;
            eb = 32'h0;
            em2reg = 0;
            ern = 5'h0;
            ewmem = 0;
            ewreg = 0;
            @(posedge clk);
            #1;
            clrn = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Checking Reset state...", test_num);
            clrn = 0;
            ealu = 32'hFFFFFFFF;
            eb = 32'hFFFFFFFF;
            em2reg = 1;
            ern = 5'h1F;
            ewmem = 1;
            ewreg = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h0, 32'h0, 1'b0, 5'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Checking standard ALU result passing...", test_num);
            reset_dut();
            ealu = 32'h12345678;
            eb = 32'hA5A5A5A5;
            em2reg = 0;
            ern = 5'd10;
            ewmem = 0;
            ewreg = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h12345678, 32'hA5A5A5A5, 1'b0, 5'd10, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Checking Store word control signals...", test_num);
            reset_dut();
            ealu = 32'h0000_1000;
            eb = 32'hDEADBEEF;
            em2reg = 0;
            ern = 5'd0;
            ewmem = 1;
            ewreg = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0000_1000, 32'hDEADBEEF, 1'b0, 5'd0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Checking Load word control signals...", test_num);
            reset_dut();
            ealu = 32'h0000_2004;
            eb = 32'h0;
            em2reg = 1;
            ern = 5'd31;
            ewmem = 0;
            ewreg = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0000_2004, 32'h0, 1'b1, 5'd31, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Checking all-ones data...", test_num);
            reset_dut();
            ealu = 32'hFFFF_FFFF;
            eb   = 32'hFFFF_FFFF;
            em2reg = 1;
            ern = 5'b11111;
            ewmem = 1;
            ewreg = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFF_FFFF, 32'hFFFF_FFFF, 1'b1, 5'b11111, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Checking synchronous update behavior...", test_num);
            reset_dut();

            ealu = 32'hAAAA_AAAA;
            eb = 32'hBBBB_BBBB;
            ern = 5'h01;
            @(posedge clk);
            #2;

            ealu = 32'h5555_5555;
            eb = 32'h0;

            #1;


            check_outputs(32'hAAAA_AAAA, 32'hBBBB_BBBB, 1'b0, 5'h01, 1'b0, 1'b0);


            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h5555_5555, 32'h0, 1'b0, 5'h01, 1'b0, 1'b0);
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
        input [31:0] expected_malu;
        input [31:0] expected_mb;
        input expected_mm2reg;
        input [4:0] expected_mrn;
        input expected_mwmem;
        input expected_mwreg;
        begin
            if (expected_malu === (expected_malu ^ malu ^ expected_malu) &&
                expected_mb === (expected_mb ^ mb ^ expected_mb) &&
                expected_mm2reg === (expected_mm2reg ^ mm2reg ^ expected_mm2reg) &&
                expected_mrn === (expected_mrn ^ mrn ^ expected_mrn) &&
                expected_mwmem === (expected_mwmem ^ mwmem ^ expected_mwmem) &&
                expected_mwreg === (expected_mwreg ^ mwreg ^ expected_mwreg)) begin
                $display("PASS");
                $display("  Outputs: malu=%h, mb=%h, mm2reg=%b, mrn=%h, mwmem=%b, mwreg=%b",
                         malu, mb, mm2reg, mrn, mwmem, mwreg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: malu=%h, mb=%h, mm2reg=%b, mrn=%h, mwmem=%b, mwreg=%b",
                         expected_malu, expected_mb, expected_mm2reg, expected_mrn, expected_mwmem, expected_mwreg);
                $display("  Got:      malu=%h, mb=%h, mm2reg=%b, mrn=%h, mwmem=%b, mwreg=%b",
                         malu, mb, mm2reg, mrn, mwmem, mwreg);
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
        $dumpvars(0,clk, clrn, ealu, eb, em2reg, ern, ewmem, ewreg, malu, mb, mm2reg, mrn, mwmem, mwreg);
    end

endmodule
