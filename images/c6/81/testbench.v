`timescale 1ns/1ps

module and_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg C;
    wire [15:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    and_module dut (
        .A(A),
        .B(B),
        .C(C),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros, Mode AND (C=0)", test_num);
            A = 16'h0000;
            B = 16'h0000;
            C = 0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros, Mode NAND (C=1)", test_num);
            A = 16'h0000;
            B = 16'h0000;
            C = 1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones, Mode AND (C=0)", test_num);
            A = 16'hFFFF;
            B = 16'hFFFF;
            C = 0;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones, Mode NAND (C=1)", test_num);
            A = 16'hFFFF;
            B = 16'hFFFF;
            C = 1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed Values (0x1234 & 0x5678), Mode AND", test_num);
            A = 16'h1234;
            B = 16'h5678;
            C = 0;

            #1;


            check_outputs(16'h1230);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed Values (0x1234 & 0x5678), Mode NAND", test_num);
            A = 16'h1234;
            B = 16'h5678;
            C = 1;

            #1;


            check_outputs(16'hEDCF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bits, Mode AND", test_num);
            A = 16'hAAAA;
            B = 16'h5555;
            C = 0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bits, Mode NAND", test_num);
            A = 16'hAAAA;
            B = 16'h5555;
            C = 1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Identical Values (0xABCD), Mode AND", test_num);
            A = 16'hABCD;
            B = 16'hABCD;
            C = 0;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Identical Values (0xABCD), Mode NAND", test_num);
            A = 16'hABCD;
            B = 16'hABCD;
            C = 1;
            #1;

            check_outputs(~16'hABCD);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("and_module Testbench");
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
        testcase010();
        
        
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
        input [15:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
