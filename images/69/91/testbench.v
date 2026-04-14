`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [31:0] ealu;
    reg [31:0] eb;
    reg em2reg;
    reg [4:0] ern;
    reg ewmem;
    reg ewreg;
    reg resetn;
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
        .clock(clock),
        .ealu(ealu),
        .eb(eb),
        .em2reg(em2reg),
        .ern(ern),
        .ewmem(ewmem),
        .ewreg(ewreg),
        .resetn(resetn),
        .malu(malu),
        .mb(mb),
        .mm2reg(mm2reg),
        .mrn(mrn),
        .mwmem(mwmem),
        .mwreg(mwreg)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            resetn = 0;
            ealu = 0;
            eb = 0;
            em2reg = 0;
            ern = 0;
            ewmem = 0;
            ewreg = 0;
            #15;
            resetn = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Checking reset state", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0, 32'h0, 1'b0, 5'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Capturing normal operation values", test_num);
            reset_dut();
            @(negedge clock);
            ealu = 32'h12345678;
            eb = 32'h87654321;
            em2reg = 1'b1;
            ern = 5'h1F;
            ewmem = 1'b0;
            ewreg = 1'b1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(32'h12345678, 32'h87654321, 1'b1, 5'h1F, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Toggling control signals", test_num);
            reset_dut();
            @(negedge clock);
            ealu = 32'hA5A5A5A5;
            eb = 32'h5A5A5A5A;
            em2reg = 1'b0;
            ern = 5'h0A;
            ewmem = 1'b1;
            ewreg = 1'b0;
            @(posedge clock);
            #2;
            #1;

            check_outputs(32'hA5A5A5A5, 32'h5A5A5A5A, 1'b0, 5'h0A, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Boundary values (All ones)", test_num);
            reset_dut();
            @(negedge clock);
            ealu = 32'hFFFFFFFF;
            eb = 32'hFFFFFFFF;
            em2reg = 1'b1;
            ern = 5'h1F;
            ewmem = 1'b1;
            ewreg = 1'b1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(32'hFFFFFFFF, 32'hFFFFFFFF, 1'b1, 5'h1F, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sequential updates", test_num);
            reset_dut();


            @(negedge clock);
            ealu = 32'h11111111; eb = 32'h22222222; ern = 5'h01;
            em2reg = 0; ewmem = 0; ewreg = 1;
            @(posedge clock);


            @(negedge clock);
            ealu = 32'h33333333; eb = 32'h44444444; ern = 5'h02;
            em2reg = 1; ewmem = 1; ewreg = 0;
            @(posedge clock);
            #2;

            #1;


            check_outputs(32'h33333333, 32'h44444444, 1'b1, 5'h02, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset during operation", test_num);
            reset_dut();


            @(negedge clock);
            ealu = 32'hD00DCAFE; eb = 32'hFEEDFACE; ern = 5'h10;
            em2reg = 1; ewmem = 1; ewreg = 1;
            @(posedge clock);
            #2;


            resetn = 0;
            #5;
            #1;

            check_outputs(32'h0, 32'h0, 1'b0, 5'h0, 1'b0, 1'b0);
            resetn = 1;
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
        $dumpvars(0,clock, ealu, eb, em2reg, ern, ewmem, ewreg, resetn, malu, mb, mm2reg, mrn, mwmem, mwreg);
    end

endmodule
