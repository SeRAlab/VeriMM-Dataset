`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] Sel;
    reg [31:0] _00;
    reg [31:0] _01;
    reg [31:0] _10;
    reg [31:0] _11;
    wire [31:0] OutMux;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Sel(Sel),
        ._00(_00),
        ._01(_01),
        ._10(_10),
        ._11(_11),
        .OutMux(OutMux)
    );
    task testcase001;

        begin
            test_num = 1;
            _00 = 32'hAAAA_AAAA;
            _01 = 32'hBBBB_BBBB;
            _10 = 32'hCCCC_CCCC;
            _11 = 32'hDDDD_DDDD;
            Sel = 2'b00;
            $display("Test Case %0d: Select _00", test_num);
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            _00 = 32'hAAAA_AAAA;
            _01 = 32'hBBBB_BBBB;
            _10 = 32'hCCCC_CCCC;
            _11 = 32'hDDDD_DDDD;
            Sel = 2'b01;
            $display("Test Case %0d: Select _01", test_num);
            #1;

            check_outputs(32'hBBBB_BBBB);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            _00 = 32'hAAAA_AAAA;
            _01 = 32'hBBBB_BBBB;
            _10 = 32'hCCCC_CCCC;
            _11 = 32'hDDDD_DDDD;
            Sel = 2'b10;
            $display("Test Case %0d: Select _10", test_num);
            #1;

            check_outputs(32'hCCCC_CCCC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            _00 = 32'hAAAA_AAAA;
            _01 = 32'hBBBB_BBBB;
            _10 = 32'hCCCC_CCCC;
            _11 = 32'hDDDD_DDDD;
            Sel = 2'b11;
            $display("Test Case %0d: Select _11", test_num);
            #1;

            check_outputs(32'hDDDD_DDDD);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            _00 = 32'h0000_0000;
            _01 = 32'hFFFF_FFFF;
            _10 = 32'h5555_5555;
            _11 = 32'hAAAA_AAAA;
            Sel = 2'b00;
            $display("Test Case %0d: Boundary Zeros", test_num);
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            _00 = 32'h0000_0000;
            _01 = 32'hFFFF_FFFF;
            _10 = 32'h5555_5555;
            _11 = 32'hAAAA_AAAA;
            Sel = 2'b01;
            $display("Test Case %0d: Boundary Ones", test_num);
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            _00 = 32'h1234_5678;
            _01 = 32'hDEAD_BEEF;
            _10 = 32'hFEED_FACE;
            _11 = 32'hCAFE_BABE;
            Sel = 2'b10;
            $display("Test Case %0d: Random Data Select 10", test_num);
            #1;

            check_outputs(32'hFEED_FACE);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            _00 = 32'h1234_5678;
            _01 = 32'hDEAD_BEEF;
            _10 = 32'hFEED_FACE;
            _11 = 32'hCAFE_BABE;
            Sel = 2'b11;
            $display("Test Case %0d: Random Data Select 11", test_num);
            #1;

            check_outputs(32'hCAFE_BABE);
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
        input [31:0] expected_OutMux;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OutMux === (expected_OutMux ^ OutMux ^ expected_OutMux)) begin
                $display("PASS");
                $display("  Outputs: OutMux=%h",
                         OutMux);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OutMux=%h",
                         expected_OutMux);
                $display("  Got:      OutMux=%h",
                         OutMux);
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
