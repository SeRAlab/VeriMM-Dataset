`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] S;
    reg [31:0] T;
    wire [63:0] prdct;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .S(S),
        .T(T),
        .prdct(prdct)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Zero Multiplication", test_num);
            S = 32'h0;
            T = 32'h0;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Identity Multiplication (1x1)", test_num);
            S = 32'h1;
            T = 32'h1;
            #1;

            check_outputs(64'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Max Input by One", test_num);
            S = 32'hFFFFFFFF;
            T = 32'h1;
            #1;

            check_outputs(64'h00000000FFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Multiplication by Zero", test_num);
            S = 32'h12345678;
            T = 32'h0;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Simple Small Values (255 * 2)", test_num);
            S = 32'd255;
            T = 32'd2;
            #1;

            check_outputs(64'd510);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Powers of 2 (Result exceeds 32 bits)", test_num);
            S = 32'h00010000;
            T = 32'h00010000;
            #1;

            check_outputs(64'h0000000100000000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Max Unsigned 32-bit (0xFFFFFFFF^2)", test_num);
            S = 32'hFFFFFFFF;
            T = 32'hFFFFFFFF;

            #1;


            check_outputs(64'hFFFFFFFF00000001);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Arbitrary Large Values", test_num);
            S = 32'hDEADBEEF;
            T = 32'hCAFEBABE;

            #1;


            check_outputs(64'hAF0B0102121B3A12);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Alternating Bit Patterns", test_num);
            S = 32'hAAAAAAAA;
            T = 32'h55555555;

            #1;


            check_outputs(64'h38E38E3871C71C72);
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
        testcase009();
        
        
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
        input [63:0] expected_prdct;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_prdct === (expected_prdct ^ prdct ^ expected_prdct)) begin
                $display("PASS");
                $display("  Outputs: prdct=%h",
                         prdct);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: prdct=%h",
                         expected_prdct);
                $display("  Got:      prdct=%h",
                         prdct);
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
