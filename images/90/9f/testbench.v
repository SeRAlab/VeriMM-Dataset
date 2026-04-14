`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] ALUO_W;
    reg [31:0] PC8_W;
    reg [31:0] RD_W;
    reg [1:0] sel;
    wire [31:0] datao;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUO_W(ALUO_W),
        .PC8_W(PC8_W),
        .RD_W(RD_W),
        .sel(sel),
        .datao(datao)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Select ALUO_W", test_num);
        ALUO_W = 32'h1111_1111;
        RD_W   = 32'h2222_2222;
        PC8_W  = 32'h3333_3333;
        sel    = 2'b00;
        #1;

        check_outputs(32'h1111_1111);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Select RD_W", test_num);
        ALUO_W = 32'hAAAA_AAAA;
        RD_W   = 32'hBBBB_BBBB;
        PC8_W  = 32'hCCCC_CCCC;
        sel    = 2'b01;
        #1;

        check_outputs(32'hBBBB_BBBB);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Select PC8_W", test_num);
        ALUO_W = 32'h1234_5678;
        RD_W   = 32'h8765_4321;
        PC8_W  = 32'hDEAD_BEEF;
        sel    = 2'b10;
        #1;

        check_outputs(32'hDEAD_BEEF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Select Default (Output 0)", test_num);
        ALUO_W = 32'hFFFF_FFFF;
        RD_W   = 32'hFFFF_FFFF;
        PC8_W  = 32'hFFFF_FFFF;
        sel    = 2'b11;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: All Zeros Input", test_num);
        ALUO_W = 32'h0;
        RD_W   = 32'h0;
        PC8_W  = 32'h0;
        sel    = 2'b00;
        #1;

        check_outputs(32'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Alternating Bits Logic", test_num);
        ALUO_W = 32'h5555_5555;
        RD_W   = 32'hAAAA_AAAA;
        PC8_W  = 32'h0000_0000;
        sel    = 2'b01;
        #1;

        check_outputs(32'hAAAA_AAAA);
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
        input [31:0] expected_datao;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_datao === (expected_datao ^ datao ^ expected_datao)) begin
                $display("PASS");
                $display("  Outputs: datao=%h",
                         datao);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: datao=%h",
                         expected_datao);
                $display("  Got:      datao=%h",
                         datao);
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

endmodule
