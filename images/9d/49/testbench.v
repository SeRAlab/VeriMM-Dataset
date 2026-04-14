`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] CA_reg;
    reg [6:0] CA_reg_set;
    reg CCSB;
    reg [15:0] CD_in_reg;
    reg CWR_pulse;
    reg Clk;
    reg [15:0] RegInit;
    reg Reset;
    wire [15:0] RegOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CA_reg(CA_reg),
        .CA_reg_set(CA_reg_set),
        .CCSB(CCSB),
        .CD_in_reg(CD_in_reg),
        .CWR_pulse(CWR_pulse),
        .Clk(Clk),
        .RegInit(RegInit),
        .Reset(Reset),
        .RegOut(RegOut)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            Reset = 1;
            CCSB = 1;
            CWR_pulse = 0;
            CA_reg = 8'h0;
            CA_reg_set = 7'h0;
            CD_in_reg = 16'h0;

            @(posedge Clk);
            #1;
            Reset = 0;
            @(posedge Clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset initialization", test_num);
            RegInit = 16'hAAAA;
            reset_dut();
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Successful Write", test_num);
            RegInit = 16'h0000;
            reset_dut();


            CA_reg_set = 7'h2A;
            CA_reg = 8'h2A;
            CCSB = 0;
            CWR_pulse = 1;
            CD_in_reg = 16'h55AA;

            @(posedge Clk);
            #1;
            CWR_pulse = 0;
            #1;

            check_outputs(16'h55AA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Address Mismatch Inhibition", test_num);
            RegInit = 16'hBBBB;
            reset_dut();

            CA_reg_set = 7'h10;
            CA_reg = 8'h11;
            CCSB = 0;
            CWR_pulse = 1;
            CD_in_reg = 16'hFFFF;

            @(posedge Clk);
            #1;
            #1;

            check_outputs(16'hBBBB);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: CCSB Inactive Inhibition", test_num);
            RegInit = 16'hCCCC;
            reset_dut();

            CA_reg_set = 7'h05;
            CA_reg = 8'h05;
            CCSB = 1;
            CWR_pulse = 1;
            CD_in_reg = 16'hEEEE;

            @(posedge Clk);
            #1;
            #1;

            check_outputs(16'hCCCC);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: CWR_pulse Inactive Inhibition", test_num);
            RegInit = 16'hDDDD;
            reset_dut();

            CA_reg_set = 7'h7F;
            CA_reg = 8'h7F;
            CCSB = 0;
            CWR_pulse = 0;
            CD_in_reg = 16'h1111;

            @(posedge Clk);
            #1;
            #1;

            check_outputs(16'hDDDD);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Sequential Writes", test_num);
            RegInit = 16'h0000;
            reset_dut();


            CA_reg_set = 7'h01;
            CA_reg = 8'h01;
            CCSB = 0;
            CWR_pulse = 1;
            CD_in_reg = 16'h1234;
            @(posedge Clk);
            #1;


            CD_in_reg = 16'h9876;
            @(posedge Clk);
            #1;
            CWR_pulse = 0;

            #1;


            check_outputs(16'h9876);
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
        input [15:0] expected_RegOut;
        begin
            if (expected_RegOut === (expected_RegOut ^ RegOut ^ expected_RegOut)) begin
                $display("PASS");
                $display("  Outputs: RegOut=%h",
                         RegOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RegOut=%h",
                         expected_RegOut);
                $display("  Got:      RegOut=%h",
                         RegOut);
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
        $dumpvars(0,CA_reg, CA_reg_set, CCSB, CD_in_reg, CWR_pulse, Clk, RegInit, Reset, RegOut);
    end

endmodule
