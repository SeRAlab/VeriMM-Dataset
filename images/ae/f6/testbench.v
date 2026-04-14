`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clrn;
    reg [31:0] malu;
    reg mm2reg;
    reg [31:0] mmo;
    reg [4:0] mrn;
    reg mwreg;
    wire [31:0] walu;
    wire wm2reg;
    wire [31:0] wmo;
    wire [4:0] wrn;
    wire wwreg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clrn(clrn),
        .malu(malu),
        .mm2reg(mm2reg),
        .mmo(mmo),
        .mrn(mrn),
        .mwreg(mwreg),
        .walu(walu),
        .wm2reg(wm2reg),
        .wmo(wmo),
        .wrn(wrn),
        .wwreg(wwreg)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clrn = 0;
            mwreg = 0;
            mm2reg = 0;
            mmo = 32'h0;
            malu = 32'h0;
            mrn = 5'h0;
            #10;
            clrn = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Latch Functional Check", test_num);
            reset_dut();


            mwreg = 1;
            mm2reg = 0;
            mmo = 32'hDEADBEEF;
            malu = 32'h12345678;
            mrn = 5'h1F;


            @(posedge clk);
            #2;


            #1;



            check_outputs(32'h12345678, 1'b0, 32'hDEADBEEF, 5'h1F, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Asynchronous Clear Check", test_num);
            reset_dut();


            mwreg = 1;
            mm2reg = 1;
            mmo = 32'hAAAA5555;
            malu = 32'h5555AAAA;
            mrn = 5'h0A;
            @(posedge clk);
            #2;


            clrn = 0;
            #2;


            #1;



            check_outputs(32'h0, 1'b0, 32'h0, 5'h0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data Stability Between Clock Edges", test_num);
            reset_dut();


            mwreg = 1;
            mm2reg = 0;
            mmo = 32'h11111111;
            malu = 32'h22222222;
            mrn = 5'h05;
            @(posedge clk);
            #2;


            mwreg = 0;
            mm2reg = 1;
            mmo = 32'hFFFFFFFF;
            malu = 32'h00000000;
            mrn = 5'h10;
            #3;


            #1;



            check_outputs(32'h22222222, 1'b0, 32'h11111111, 5'h05, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Control Signals and All-Ones Latch", test_num);
            reset_dut();

            mwreg = 0;
            mm2reg = 1;
            mmo = 32'hFFFFFFFF;
            malu = 32'hFFFFFFFF;
            mrn = 5'h1F;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hFFFFFFFF, 1'b1, 32'hFFFFFFFF, 5'h1F, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequential Transfers", test_num);
            reset_dut();


            mwreg = 1; mm2reg = 1; mmo = 32'hC0DE1; malu = 32'hBEEF1; mrn = 5'h01;
            @(posedge clk);
            #2;


            mwreg = 0; mm2reg = 0; mmo = 32'hC0DE2; malu = 32'hBEEF2; mrn = 5'h02;
            @(posedge clk);
            #2;


            #1;



            check_outputs(32'hBEEF2, 1'b0, 32'hC0DE2, 5'h02, 1'b0);
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
        input [31:0] expected_walu;
        input expected_wm2reg;
        input [31:0] expected_wmo;
        input [4:0] expected_wrn;
        input expected_wwreg;
        begin
            if (expected_walu === (expected_walu ^ walu ^ expected_walu) &&
                expected_wm2reg === (expected_wm2reg ^ wm2reg ^ expected_wm2reg) &&
                expected_wmo === (expected_wmo ^ wmo ^ expected_wmo) &&
                expected_wrn === (expected_wrn ^ wrn ^ expected_wrn) &&
                expected_wwreg === (expected_wwreg ^ wwreg ^ expected_wwreg)) begin
                $display("PASS");
                $display("  Outputs: walu=%h, wm2reg=%b, wmo=%h, wrn=%h, wwreg=%b",
                         walu, wm2reg, wmo, wrn, wwreg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: walu=%h, wm2reg=%b, wmo=%h, wrn=%h, wwreg=%b",
                         expected_walu, expected_wm2reg, expected_wmo, expected_wrn, expected_wwreg);
                $display("  Got:      walu=%h, wm2reg=%b, wmo=%h, wrn=%h, wwreg=%b",
                         walu, wm2reg, wmo, wrn, wwreg);
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
        $dumpvars(0,clk, clrn, malu, mm2reg, mmo, mrn, mwreg, walu, wm2reg, wmo, wrn, wwreg);
    end

endmodule
