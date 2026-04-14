`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLRbar;
    reg PREbar;
    reg clock;
    reg [31:0] data;
    wire Wen;
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
        .clock(clock),
        .data(data),
        .Wen(Wen),
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
        CLRbar = 1'b1;
        PREbar = 1'b1;
        Wen = 1'b0;
        data = 32'h0;

        #2 CLRbar = 1'b0;
        #5 CLRbar = 1'b1;
        @(posedge clock);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        CLRbar = 1'b0;
        #2;
        #1;

        check_outputs(Wen, 32'h00000000, 32'hFFFFFFFF);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        PREbar = 1'b0;
        #2;
        #1;

        check_outputs(Wen, 32'hFFFFFFFF, 32'h00000000);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        CLRbar = 1'b1;
        PREbar = 1'b1;
        Wen = 1'b1;
        data = 32'hA5A5A5A5;
        @(posedge clock);
        #2;
        #1;

        check_outputs(1'b1, 32'hA5A5A5A5, 32'h5A5A5A5A);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;

        Wen = 1'b1;
        data = 32'h12345678;
        @(posedge clock);
        #1;

        Wen = 1'b0;
        data = 32'hFFFFFFFF;
        @(posedge clock);
        #2;

        #1;


        check_outputs(1'b0, 32'h12345678, ~32'h12345678);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        CLRbar = 1'b0;
        PREbar = 1'b0;
        #2;


        #1;



        check_outputs(Wen, 32'h0, 32'hFFFFFFFF);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        CLRbar = 1'b1;
        PREbar = 1'b1;
        Wen = 1'b1;
        data = 32'hFFFFFFFF;
        @(posedge clock);
        #2;
        #1;

        check_outputs(1'b1, 32'hFFFFFFFF, 32'h00000000);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        Wen = 1'b1;
        data = 32'hCAFEFACE;
        @(posedge clock);
        #2;
        #1;

        check_outputs(1'b1, 32'hCAFEFACE, ~32'hCAFEFACE);
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
        input expected_Wen;
        input [31:0] expected_q;
        input [31:0] expected_qbar;
        begin
            if (expected_Wen === (expected_Wen ^ Wen ^ expected_Wen) &&
                expected_q === (expected_q ^ q ^ expected_q) &&
                expected_qbar === (expected_qbar ^ qbar ^ expected_qbar)) begin
                $display("PASS");
                $display("  Outputs: Wen=%b, q=%h, qbar=%h",
                         Wen, q, qbar);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Wen=%b, q=%h, qbar=%h",
                         expected_Wen, expected_q, expected_qbar);
                $display("  Got:      Wen=%b, q=%h, qbar=%h",
                         Wen, q, qbar);
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
        $dumpvars(0,CLRbar, PREbar, clock, data, Wen, q, qbar);
    end

endmodule
