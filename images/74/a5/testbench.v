`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] In0;
    reg [31:0] In1;
    reg Sel;
    wire [31:0] Out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .In0(In0),
        .In1(In1),
        .Sel(Sel),
        .Out(Out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select In0 with specific pattern", test_num);
            In0 = 32'hAAAA_AAAA;
            In1 = 32'h5555_5555;
            Sel = 1'b0;
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select In1 with specific pattern", test_num);
            In0 = 32'hAAAA_AAAA;
            In1 = 32'h5555_5555;
            Sel = 1'b1;
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select In0 with all Fs", test_num);
            In0 = 32'hFFFF_FFFF;
            In1 = 32'h0000_0000;
            Sel = 1'b0;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select In1 with all 0s", test_num);
            In0 = 32'hFFFF_FFFF;
            In1 = 32'h0000_0000;
            Sel = 1'b1;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select In0 with walking bit pattern", test_num);
            In0 = 32'h1234_5678;
            In1 = 32'hFEDC_BA98;
            Sel = 1'b0;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select In1 with walking bit pattern", test_num);
            In0 = 32'h1234_5678;
            In1 = 32'hFEDC_BA98;
            Sel = 1'b1;
            #1;

            check_outputs(32'hFEDC_BA98);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify output changes when input In0 changes (Sel=0)", test_num);
            In1 = 32'h0;
            Sel = 1'b0;
            In0 = 32'hCAFE_BABE;
            #1;

            check_outputs(32'hCAFE_BABE);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify output changes when input In1 changes (Sel=1)", test_num);
            In0 = 32'h0;
            Sel = 1'b1;
            In1 = 32'hDEAD_BEEF;
            #1;

            check_outputs(32'hDEAD_BEEF);
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
        input [31:0] expected_Out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Out === (expected_Out ^ Out ^ expected_Out)) begin
                $display("PASS");
                $display("  Outputs: Out=%h",
                         Out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Out=%h",
                         expected_Out);
                $display("  Got:      Out=%h",
                         Out);
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
