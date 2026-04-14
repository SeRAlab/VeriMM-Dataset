`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [31:0] eAlu;
    reg [31:0] eb;
    reg em2reg;
    reg [4:0] ern;
    reg ewmem;
    reg ewreg;
    reg resetn;
    wire [31:0] mAlu;
    wire [31:0] mB;
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
        .eAlu(eAlu),
        .eb(eb),
        .em2reg(em2reg),
        .ern(ern),
        .ewmem(ewmem),
        .ewreg(ewreg),
        .resetn(resetn),
        .mAlu(mAlu),
        .mB(mB),
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
            ewreg = 0;
            em2reg = 0;
            ewmem = 0;
            eAlu = 0;
            eb = 0;
            ern = 0;
            #15;
            resetn = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Reset State Verification", test_num);
            reset_dut();

            ewreg = 1; eAlu = 32'hFFFFFFFF;

            #1;


            check_outputs(32'h0, 32'h0, 1'b0, 5'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Basic Data Pass-through", test_num);
            reset_dut();


            ewreg = 1;
            em2reg = 1;
            ewmem = 0;
            eAlu = 32'h12345678;
            eb = 32'hABCDEFFF;
            ern = 5'd15;

            @(posedge clock);
            #2;

            #1;


            check_outputs(32'h12345678, 32'hABCDEFFF, 1'b1, 5'd15, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Alternate Control Signals", test_num);
            reset_dut();

            ewreg = 0;
            em2reg = 0;
            ewmem = 1;
            eAlu = 32'hDEADBEEF;
            eb = 32'hCAFEBABE;
            ern = 5'd31;

            @(posedge clock);
            #2;

            #1;


            check_outputs(32'hDEADBEEF, 32'hCAFEBABE, 1'b0, 5'd31, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Data Stability", test_num);
            reset_dut();


            ewreg = 1; em2reg = 1; ewmem = 1;
            eAlu = 32'hAAAAAAAA; eb = 32'h55555555; ern = 5'd10;
            @(posedge clock);
            #2;


            eAlu = 32'h0; eb = 32'h0;
            #5;


            #1;



            check_outputs(32'hAAAAAAAA, 32'h55555555, 1'b1, 5'd10, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Zero Values", test_num);
            reset_dut();


            ewreg = 1; eAlu = 32'h1; eb = 32'h1; ern = 5'h1;
            @(posedge clock);
            #2;


            ewreg = 0; em2reg = 0; ewmem = 0;
            eAlu = 32'h0; eb = 32'h0; ern = 5'h0;
            @(posedge clock);
            #2;

            #1;


            check_outputs(32'h0, 32'h0, 1'b0, 5'h0, 1'b0, 1'b0);
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
        input [31:0] expected_mAlu;
        input [31:0] expected_mB;
        input expected_mm2reg;
        input [4:0] expected_mrn;
        input expected_mwmem;
        input expected_mwreg;
        begin
            if (expected_mAlu === (expected_mAlu ^ mAlu ^ expected_mAlu) &&
                expected_mB === (expected_mB ^ mB ^ expected_mB) &&
                expected_mm2reg === (expected_mm2reg ^ mm2reg ^ expected_mm2reg) &&
                expected_mrn === (expected_mrn ^ mrn ^ expected_mrn) &&
                expected_mwmem === (expected_mwmem ^ mwmem ^ expected_mwmem) &&
                expected_mwreg === (expected_mwreg ^ mwreg ^ expected_mwreg)) begin
                $display("PASS");
                $display("  Outputs: mAlu=%h, mB=%h, mm2reg=%b, mrn=%h, mwmem=%b, mwreg=%b",
                         mAlu, mB, mm2reg, mrn, mwmem, mwreg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mAlu=%h, mB=%h, mm2reg=%b, mrn=%h, mwmem=%b, mwreg=%b",
                         expected_mAlu, expected_mB, expected_mm2reg, expected_mrn, expected_mwmem, expected_mwreg);
                $display("  Got:      mAlu=%h, mB=%h, mm2reg=%b, mrn=%h, mwmem=%b, mwreg=%b",
                         mAlu, mB, mm2reg, mrn, mwmem, mwreg);
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
        $dumpvars(0,clock, eAlu, eb, em2reg, ern, ewmem, ewreg, resetn, mAlu, mB, mm2reg, mrn, mwmem, mwreg);
    end

endmodule
