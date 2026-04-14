`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] ad_i;
    reg [6:0] bar0_i;
    reg [3:0] cbe_i;
    reg clk_i;
    reg idsel_i;
    reg memEN_i;
    reg nrst_i;
    reg pciadrLD_i;
    wire [23:0] adr_o;
    wire adrcfg_o;
    wire adrmem_o;
    wire [3:0] cmd_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ad_i(ad_i),
        .bar0_i(bar0_i),
        .cbe_i(cbe_i),
        .clk_i(clk_i),
        .idsel_i(idsel_i),
        .memEN_i(memEN_i),
        .nrst_i(nrst_i),
        .pciadrLD_i(pciadrLD_i),
        .adr_o(adr_o),
        .adrcfg_o(adrcfg_o),
        .adrmem_o(adrmem_o),
        .cmd_o(cmd_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

    begin
        nrst_i = 0;
        ad_i = 0;
        bar0_i = 0;
        cbe_i = 0;
        idsel_i = 0;
        memEN_i = 0;
        pciadrLD_i = 0;
        #10;
        nrst_i = 1;
        #10;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %03d: Memory Access Hit", test_num);



        bar0_i = 7'h55;
        ad_i = 32'hAA001234;
        cbe_i = 4'h7;
        memEN_i = 1;
        pciadrLD_i = 1;
        idsel_i = 0;

        @(posedge clk_i);
        #2;
        pciadrLD_i = 0;

        #1;


        check_outputs(24'h001234, 1'b0, 1'b1, 4'h7);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %03d: Configuration Access", test_num);

        bar0_i = 7'h00;
        ad_i = 32'h000000F0;
        cbe_i = 4'hA;
        memEN_i = 0;
        idsel_i = 1;
        pciadrLD_i = 1;

        @(posedge clk_i);
        #2;
        pciadrLD_i = 0;

        #1;


        check_outputs(24'h0000F0, 1'b1, 1'b0, 4'hA);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %03d: Memory Access Miss (Address)", test_num);

        bar0_i = 7'h55;
        ad_i = 32'hBB001234;
        cbe_i = 4'h7;
        memEN_i = 1;
        pciadrLD_i = 1;

        @(posedge clk_i);
        #2;

        #1;


        check_outputs(24'h001234, 1'b0, 1'b0, 4'h7);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %03d: Memory Access Miss (memEN disabled)", test_num);

        bar0_i = 7'h55;
        ad_i = 32'hAA001234;
        cbe_i = 4'h7;
        memEN_i = 0;
        pciadrLD_i = 1;

        @(posedge clk_i);
        #2;

        #1;


        check_outputs(24'h001234, 1'b0, 1'b0, 4'h7);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %03d: State Persistence Check", test_num);


        bar0_i = 7'h20;
        ad_i = 32'h40ABCDEF;
        cbe_i = 4'h6;
        memEN_i = 1;
        pciadrLD_i = 1;
        @(posedge clk_i);
        #2;


        pciadrLD_i = 0;
        ad_i = 32'hFFFFFFFF;
        cbe_i = 4'h0;
        @(posedge clk_i);
        #2;


        #1;



        check_outputs(24'hABCDEF, 1'b0, 1'b1, 4'h6);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Testcase %03d: Reset Behavior", test_num);


        bar0_i = 7'h20;
        ad_i = 32'h40ABCDEF;
        cbe_i = 4'h6;
        memEN_i = 1;
        pciadrLD_i = 1;
        @(posedge clk_i);
        #2;


        nrst_i = 0;
        #10;


        #1;



        check_outputs(24'h000000, 1'b0, 1'b0, 4'h0);
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
        input [23:0] expected_adr_o;
        input expected_adrcfg_o;
        input expected_adrmem_o;
        input [3:0] expected_cmd_o;
        begin
            if (expected_adr_o === (expected_adr_o ^ adr_o ^ expected_adr_o) &&
                expected_adrcfg_o === (expected_adrcfg_o ^ adrcfg_o ^ expected_adrcfg_o) &&
                expected_adrmem_o === (expected_adrmem_o ^ adrmem_o ^ expected_adrmem_o) &&
                expected_cmd_o === (expected_cmd_o ^ cmd_o ^ expected_cmd_o)) begin
                $display("PASS");
                $display("  Outputs: adr_o=%h, adrcfg_o=%b, adrmem_o=%b, cmd_o=%h",
                         adr_o, adrcfg_o, adrmem_o, cmd_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adr_o=%h, adrcfg_o=%b, adrmem_o=%b, cmd_o=%h",
                         expected_adr_o, expected_adrcfg_o, expected_adrmem_o, expected_cmd_o);
                $display("  Got:      adr_o=%h, adrcfg_o=%b, adrmem_o=%b, cmd_o=%h",
                         adr_o, adrcfg_o, adrmem_o, cmd_o);
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
        $dumpvars(0,ad_i, bar0_i, cbe_i, clk_i, idsel_i, memEN_i, nrst_i, pciadrLD_i, adr_o, adrcfg_o, adrmem_o, cmd_o);
    end

endmodule
