`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] EXT_E;
    reg [31:0] MFALUBEO;
    reg [1:0] sel;
    wire [31:0] datao;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EXT_E(EXT_E),
        .MFALUBEO(MFALUBEO),
        .sel(sel),
        .datao(datao)
    );
    task testcase001;

        begin
            test_num = 1;
            MFALUBEO = 32'hAAAAAAAA;
            EXT_E    = 32'h55555555;
            sel      = 2'b00;
            $display("Test Case %0d: Selecting MFALUBEO (sel=00)", test_num);
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            MFALUBEO = 32'h12345678;
            EXT_E    = 32'h9ABCDEF0;
            sel      = 2'b01;
            $display("Test Case %0d: Selecting EXT_E (sel=01)", test_num);
            #1;

            check_outputs(32'h9ABCDEF0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            MFALUBEO = 32'hFFFFFFFF;
            EXT_E    = 32'hEEEEEEEE;
            sel      = 2'b10;
            $display("Test Case %0d: Defaulting to zero (sel=10)", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            MFALUBEO = 32'hDEADBEEF;
            EXT_E    = 32'hCAFEBABE;
            sel      = 2'b11;
            $display("Test Case %0d: Defaulting to zero (sel=11)", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            MFALUBEO = 32'h00000001;
            EXT_E    = 32'h80000000;
            sel      = 2'b00;
            $display("Test Case %0d: Toggle check MFALUBEO (sel=00)", test_num);
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            MFALUBEO = 32'h00000001;
            EXT_E    = 32'h80000000;
            sel      = 2'b01;
            $display("Test Case %0d: Toggle check EXT_E (sel=01)", test_num);
            #1;

            check_outputs(32'h80000000);
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
