`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg D_IN;
    reg EN;
    reg RST;
    wire Q_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D_IN(D_IN),
        .EN(EN),
        .RST(RST),
        .Q_OUT(Q_OUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        RST = 1;
        EN = 0;
        D_IN = 0;
        @(posedge CLK);
        #1;
        RST = 0;
        @(negedge CLK);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Synchronous Reset Check", test_num);
        reset_dut();

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Load Data High (EN=1, D_IN=1)", test_num);
        reset_dut();
        @(negedge CLK);
        EN = 1;
        D_IN = 1;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Load Data Low (EN=1, D_IN=0)", test_num);
        reset_dut();

        @(negedge CLK);
        EN = 1; D_IN = 1;
        @(posedge CLK);

        @(negedge CLK);
        D_IN = 0;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Data Stability when EN=0", test_num);
        reset_dut();

        @(negedge CLK);
        EN = 1; D_IN = 1;
        @(posedge CLK);

        @(negedge CLK);
        EN = 0; D_IN = 0;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Synchronous Reset Priority over EN", test_num);
        reset_dut();

        @(negedge CLK);
        RST = 1;
        EN = 1;
        D_IN = 1;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(1'b0);
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
        input expected_Q_OUT;
        begin
            if (expected_Q_OUT === (expected_Q_OUT ^ Q_OUT ^ expected_Q_OUT)) begin
                $display("PASS");
                $display("  Outputs: Q_OUT=%b",
                         Q_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q_OUT=%b",
                         expected_Q_OUT);
                $display("  Got:      Q_OUT=%b",
                         Q_OUT);
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
        $dumpvars(0,CLK, D_IN, EN, RST, Q_OUT);
    end

endmodule
