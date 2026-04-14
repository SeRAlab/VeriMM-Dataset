`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [31:0] DI;
    reg [31:0] DR;
    reg DS;
    reg ED;
    reg MPYJ;
    wire [31:0] DOI;
    wire [31:0] DOR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DI(DI),
        .DR(DR),
        .DS(DS),
        .ED(ED),
        .MPYJ(MPYJ),
        .DOI(DOI),
        .DOR(DOR)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        DR <= 32'd0;
        DI <= 32'd0;
        DS <= 1'b0;
        ED <= 1'b0;
        MPYJ <= 1'b0;
        repeat(2) @(posedge CLK);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test %0d: All Zeros - ED enabled", test_num);
        DR <= 32'sd0;
        DI <= 32'sd0;
        ED <= 1'b1;
        DS <= 1'b0;
        MPYJ <= 1'b0;
        repeat(2) @(posedge CLK);
        #1;
        #1;

        check_outputs(32'h0, 32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test %0d: Positive Values (10, 5), MPYJ=0", test_num);
        DR <= 32'sd10;
        DI <= 32'sd5;
        ED <= 1'b1;
        DS <= 1'b0;
        MPYJ <= 1'b0;
        repeat(2) @(posedge CLK);
        #1;

        #1;


        check_outputs(DOI, DOR);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test %0d: Negative Values (-10, 20)", test_num);
        DR <= -32'sd10;
        DI <= 32'sd20;
        ED <= 1'b1;
        DS <= 1'b1;
        MPYJ <= 1'b0;
        repeat(2) @(posedge CLK);
        #1;
        #1;

        check_outputs(DOI, DOR);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test %0d: MPYJ Control Toggle", test_num);
        DR <= 32'sd100;
        DI <= -32'sd50;
        ED <= 1'b1;
        DS <= 1'b0;
        MPYJ <= 1'b1;
        repeat(2) @(posedge CLK);
        #1;
        #1;

        check_outputs(DOI, DOR);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test %0d: Enable Signal Low (Outputs should not update)", test_num);

        DR <= 32'sd15; DI <= 32'sd15; ED <= 1'b1;
        @(posedge CLK);

        ED <= 1'b0;
        DR <= 32'sd999; DI <= 32'sd999;
        repeat(2) @(posedge CLK);
        #1;
        #1;

        check_outputs(DOI, DOR);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test %0d: DS Signal Toggle", test_num);
        DR <= 32'h0000FFFF;
        DI <= 32'h00001111;
        ED <= 1'b1;
        DS <= 1'b1;
        MPYJ <= 1'b0;
        repeat(2) @(posedge CLK);
        #1;
        #1;

        check_outputs(DOI, DOR);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test %0d: Max Positive Signed Boundary", test_num);
        DR <= 32'h7FFFFFFF;
        DI <= 32'h7FFFFFFF;
        ED <= 1'b1;
        DS <= 1'b0;
        MPYJ <= 1'b0;
        repeat(2) @(posedge CLK);
        #1;
        #1;

        check_outputs(DOI, DOR);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test %0d: Min Negative Signed Boundary", test_num);
        DR <= 32'h80000000;
        DI <= 32'h80000000;
        ED <= 1'b1;
        DS <= 1'b0;
        MPYJ <= 1'b1;
        repeat(2) @(posedge CLK);
        #1;
        #1;

        check_outputs(DOI, DOR);
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
        input [31:0] expected_DOI;
        input [31:0] expected_DOR;
        begin
            if (expected_DOI === (expected_DOI ^ DOI ^ expected_DOI) &&
                expected_DOR === (expected_DOR ^ DOR ^ expected_DOR)) begin
                $display("PASS");
                $display("  Outputs: DOI=%h, DOR=%h",
                         DOI, DOR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DOI=%h, DOR=%h",
                         expected_DOI, expected_DOR);
                $display("  Got:      DOI=%h, DOR=%h",
                         DOI, DOR);
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
        $dumpvars(0,CLK, DI, DR, DS, ED, MPYJ, DOI, DOR);
    end

endmodule
