`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] dIn0;
    reg [31:0] dIn1;
    reg [31:0] dIn2;
    reg [31:0] dIn3;
    reg [1:0] sel;
    wire [31:0] dOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dIn0(dIn0),
        .dIn1(dIn1),
        .dIn2(dIn2),
        .dIn3(dIn3),
        .sel(sel),
        .dOut(dOut)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Select dIn0", test_num);
            sel = 2'b00;
            dIn0 = 32'hAAAA_AAAA;
            dIn1 = 32'hBBBB_BBBB;
            dIn2 = 32'hCCCC_CCCC;
            dIn3 = 32'hDDDD_DDDD;
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select dIn1", test_num);
            sel = 2'b01;
            dIn0 = 32'h1111_1111;
            dIn1 = 32'h2222_2222;
            dIn2 = 32'h3333_3333;
            dIn3 = 32'h4444_4444;
            #1;

            check_outputs(32'h2222_2222);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select dIn2", test_num);
            sel = 2'b10;
            dIn0 = 32'hDEAD_BEEF;
            dIn1 = 32'hCAFE_BABE;
            dIn2 = 32'h0123_4567;
            dIn3 = 32'h89AB_CDEF;
            #1;

            check_outputs(32'h0123_4567);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Select dIn3", test_num);
            sel = 2'b11;
            dIn0 = 32'hFFFF_FFFF;
            dIn1 = 32'h0000_0000;
            dIn2 = 32'h5555_5555;
            dIn3 = 32'hAAAA_5555;
            #1;

            check_outputs(32'hAAAA_5555);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Check All Zeros on dIn0", test_num);
            sel = 2'b00;
            dIn0 = 32'h0000_0000;
            dIn1 = 32'hFFFF_FFFF;
            dIn2 = 32'hFFFF_FFFF;
            dIn3 = 32'hFFFF_FFFF;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Check All Ones on dIn2", test_num);
            sel = 2'b10;
            dIn0 = 32'h0000_0000;
            dIn1 = 32'h0000_0000;
            dIn2 = 32'hFFFF_FFFF;
            dIn3 = 32'h0000_0000;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Alternating bit patterns on dIn3", test_num);
            sel = 2'b11;
            dIn0 = 32'h0F0F_0F0F;
            dIn1 = 32'hF0F0_F0F0;
            dIn2 = 32'hCCCC_3333;
            dIn3 = 32'hA5A5_5A5A;
            #1;

            check_outputs(32'hA5A5_5A5A);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Walking data on dIn1", test_num);
            sel = 2'b01;
            dIn0 = 32'h0000_0000;
            dIn1 = 32'h8000_0000;
            dIn2 = 32'h0000_0000;
            dIn3 = 32'h0000_0000;
            #1;

            check_outputs(32'h8000_0000);
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
        input [31:0] expected_dOut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dOut === (expected_dOut ^ dOut ^ expected_dOut)) begin
                $display("PASS");
                $display("  Outputs: dOut=%h",
                         dOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dOut=%h",
                         expected_dOut);
                $display("  Got:      dOut=%h",
                         dOut);
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
