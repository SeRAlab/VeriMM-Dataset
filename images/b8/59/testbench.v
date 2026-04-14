`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clkx2;
    reg jrst_n;
    reg [35:0] tw;
    wire tr_clk;
    wire [17:0] tr_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clkx2(clkx2),
        .jrst_n(jrst_n),
        .tw(tw),
        .tr_clk(tr_clk),
        .tr_data(tr_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        jrst_n = 0;
        tw = 36'h0;
        #15;
        jrst_n = 1;
        #5;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Checking Reset State", test_num);
        reset_dut();

        jrst_n = 0;
        #1;
        #1;

        check_outputs(1'b0, 18'h0);
        jrst_n = 1;
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Checking Lower Half Data (Phase 0)", test_num);
        reset_dut();
        tw = {18'h3AAAA, 18'h15555};
        repeat(2) @(posedge clkx2);
        #1;

        #1;


        check_outputs(tr_clk, 18'h15555);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Checking Upper Half Data (Phase 1)", test_num);
        reset_dut();
        tw = {18'h3AAAA, 18'h15555};
        repeat(3) @(posedge clkx2);
        #1;

        #1;


        check_outputs(tr_clk, 18'h3AAAA);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Pattern Toggle Check", test_num);
        reset_dut();
        tw = {18'h3FFFF, 18'h00000};
        repeat(4) @(posedge clkx2);
        #1;


        if (tr_data == 18'h3FFFF || tr_data == 18'h00000)
            #1;

            check_outputs(tr_clk, tr_data);
        else
            #1;

            check_outputs(tr_clk, 18'h00000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Mid-operation Data Update", test_num);
        reset_dut();
        tw = 36'hF0F0F0F0F;
        repeat(4) @(posedge clk);
        tw = 36'hCAFEBABEE;
        repeat(2) @(posedge clkx2);
        #1;

        #1;


        check_outputs(tr_clk, 18'h2ABEE);
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
        input expected_tr_clk;
        input [17:0] expected_tr_data;
        begin
            if (expected_tr_clk === (expected_tr_clk ^ tr_clk ^ expected_tr_clk) &&
                expected_tr_data === (expected_tr_data ^ tr_data ^ expected_tr_data)) begin
                $display("PASS");
                $display("  Outputs: tr_clk=%b, tr_data=%h",
                         tr_clk, tr_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tr_clk=%b, tr_data=%h",
                         expected_tr_clk, expected_tr_data);
                $display("  Got:      tr_clk=%b, tr_data=%h",
                         tr_clk, tr_data);
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
        $dumpvars(0,clk, clkx2, jrst_n, tw, tr_clk, tr_data);
    end

endmodule
