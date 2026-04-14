`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] SrcAE;
    reg [31:0] SrcBE;
    wire [31:0] AGOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .SrcAE(SrcAE),
        .SrcBE(SrcBE),
        .AGOut(AGOut)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple addition", test_num);
            SrcAE = 32'h0000_0005;
            SrcBE = 32'h0000_000A;
            #1;

            check_outputs(32'h0000_000F);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All zeros", test_num);
            SrcAE = 32'h0000_0000;
            SrcBE = 32'h0000_0000;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum value wrap-around", test_num);
            SrcAE = 32'hFFFF_FFFF;
            SrcBE = 32'h0000_0001;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large values addition", test_num);
            SrcAE = 32'h1234_5678;
            SrcBE = 32'h8765_4321;
            #1;

            check_outputs(32'h9999_9999);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bit pattern - Alternating bits", test_num);
            SrcAE = 32'hAAAA_AAAA;
            SrcBE = 32'h5555_5555;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Carry propagation across all bits", test_num);
            SrcAE = 32'hFFFF_FFFF;
            SrcBE = 32'hFFFF_FFFF;
            #1;

            check_outputs(32'hFFFE_FFFE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed-like boundary addition (7FFFFFFF + 1)", test_num);
            SrcAE = 32'h7FFF_FFFF;
            SrcBE = 32'h0000_0001;
            #1;

            check_outputs(32'h8000_0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random hexadecimal patterns", test_num);
            SrcAE = 32'hDEAD_BEEF;
            SrcBE = 32'h1234_5678;
            #1;

            check_outputs(32'hF0E2_1567);
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
        input [31:0] expected_AGOut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_AGOut === (expected_AGOut ^ AGOut ^ expected_AGOut)) begin
                $display("PASS");
                $display("  Outputs: AGOut=%h",
                         AGOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: AGOut=%h",
                         expected_AGOut);
                $display("  Got:      AGOut=%h",
                         AGOut);
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
