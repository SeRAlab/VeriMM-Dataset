`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg aset;
    reg clk_en;
    reg clock;
    reg cnt_en;
    reg [31:0] data;
    reg sload;
    wire [31:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aset(aset),
        .clk_en(clk_en),
        .clock(clock),
        .cnt_en(cnt_en),
        .data(data),
        .sload(sload),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        aset = 1;
        clk_en = 0;
        cnt_en = 0;
        sload = 0;
        data = 0;
        #12;
        aset = 0;
        @(posedge clock);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Asynchronous Reset check", test_num);
        reset_dut();


        #1;



        check_outputs(32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Synchronous Load", test_num);
        reset_dut();
        data = 32'hDEADBEEF;
        sload = 1;
        @(posedge clock);
        #1;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Increment", test_num);
        reset_dut();
        clk_en = 1;
        cnt_en = 1;
        repeat (5) @(posedge clock);
        #1;
        #1;

        check_outputs(32'd5);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Clock Enable Gating", test_num);
        reset_dut();
        clk_en = 0;
        cnt_en = 1;
        repeat (5) @(posedge clock);
        #1;
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Count Enable Gating", test_num);
        reset_dut();
        clk_en = 1;
        cnt_en = 0;
        repeat (5) @(posedge clock);
        #1;
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sload Priority", test_num);
        reset_dut();
        data = 32'h12345678;
        sload = 1;
        clk_en = 1;
        cnt_en = 1;
        @(posedge clock);
        #1;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Rollover check", test_num);
        reset_dut();

        data = 32'hFFFFFFFF;
        sload = 1;
        @(posedge clock);
        #1;

        sload = 0;
        clk_en = 1;
        cnt_en = 1;
        @(posedge clock);
        #1;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Load then increment", test_num);
        reset_dut();
        data = 32'h000000FF;
        sload = 1;
        @(posedge clock);
        #1;
        sload = 0;
        clk_en = 1;
        cnt_en = 1;
        repeat (2) @(posedge clock);
        #1;
        #1;

        check_outputs(32'h00000101);
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
        input [31:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,aset, clk_en, clock, cnt_en, data, sload, q);
    end

endmodule
