`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    wire [31:0] B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 32'h00000000;
            $display("Test %0d: Zero input", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 32'h00000001;
            $display("Test %0d: Shift LSB by 4", test_num);
            #1;

            check_outputs(32'h00000010);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 32'hFFFFFFFF;
            $display("Test %0d: All ones (MSB nibble discarded)", test_num);
            #1;

            check_outputs(32'hFFFFFFF0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 32'hF0000000;
            $display("Test %0d: Input only in MSB nibble (should result in zero)", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 32'h0F000000;
            $display("Test %0d: Shift second nibble to first", test_num);
            #1;

            check_outputs(32'hF0000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 32'h55555555;
            $display("Test %0d: Alternating bits pattern", test_num);
            #1;

            check_outputs(32'h55555550);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 32'h12345678;
            $display("Test %0d: Standard hex sequence", test_num);
            #1;

            check_outputs(32'h23456780);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 32'hDEADBEEF;
            $display("Test %0d: Specific hex pattern", test_num);
            #1;

            check_outputs(32'hEADBEEF0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = 32'h0000000F;
            $display("Test %0d: LSB nibble full", test_num);
            #1;

            check_outputs(32'h000000F0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            A = 32'h80000008;
            $display("Test %0d: Boundary bits", test_num);
            #1;

            check_outputs(32'h00000080);
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
        input [31:0] expected_B;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_B === (expected_B ^ B ^ expected_B)) begin
                $display("PASS");
                $display("  Outputs: B=%h",
                         B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: B=%h",
                         expected_B);
                $display("  Got:      B=%h",
                         B);
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
