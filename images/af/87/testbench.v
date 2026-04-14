`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLRbar;
    reg PREbar;
    reg Wen;
    reg clock;
    reg [31:0] data;
    wire [31:0] q;
    wire [31:0] qbar;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLRbar(CLRbar),
        .PREbar(PREbar),
        .Wen(Wen),
        .clock(clock),
        .data(data),
        .q(q),
        .qbar(qbar)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        CLRbar = 0;
        PREbar = 1;
        Wen = 0;
        data = 0;
        @(posedge clock);
        #1;
        CLRbar = 1;
        @(posedge clock);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %0d: Basic Write Enable", test_num);
        data = 32'hDEADBEEF;
        Wen = 1;
        CLRbar = 1;
        PREbar = 1;
        @(posedge clock);
        #1;
        #1;

        check_outputs(32'hDEADBEEF, ~32'hDEADBEEF);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %0d: Write Enable Low (Data Hold)", test_num);

        data = 32'h12345678;
        Wen = 1;
        @(posedge clock);
        #1;

        data = 32'h87654321;
        Wen = 0;
        @(posedge clock);
        #1;
        #1;

        check_outputs(32'h12345678, ~32'h12345678);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %0d: Synchronous Clear", test_num);

        data = 32'hFFFFFFFF;
        Wen = 1;
        @(posedge clock);
        #1;

        CLRbar = 0;
        @(posedge clock);
        #1;
        #1;

        check_outputs(32'h00000000, 32'hFFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %0d: Synchronous Preset", test_num);
        CLRbar = 1;
        PREbar = 0;
        @(posedge clock);
        #1;
        #1;

        check_outputs(32'hFFFFFFFF, 32'h00000000);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %0d: Priority - Clear vs Write Enable", test_num);
        data = 32'hAAAA5555;
        Wen = 1;
        CLRbar = 0;
        PREbar = 1;
        @(posedge clock);
        #1;
        #1;

        check_outputs(32'h00000000, 32'hFFFFFFFF);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Testcase %0d: Check qbar bitwise inversion", test_num);
        data = 32'h5A5A5A5A;
        Wen = 1;
        @(posedge clock);
        #1;
        #1;

        check_outputs(32'h5A5A5A5A, 32'hA5A5A5A5);
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
        input [31:0] expected_q;
        input [31:0] expected_qbar;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_qbar === (expected_qbar ^ qbar ^ expected_qbar)) begin
                $display("PASS");
                $display("  Outputs: q=%h, qbar=%h",
                         q, qbar);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h, qbar=%h",
                         expected_q, expected_qbar);
                $display("  Got:      q=%h, qbar=%h",
                         q, qbar);
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
        $dumpvars(0,CLRbar, PREbar, Wen, clock, data, q, qbar);
    end

endmodule
