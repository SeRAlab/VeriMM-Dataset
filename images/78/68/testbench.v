`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] real_RFRD1;
    reg [31:0] real_RFRD2;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .real_RFRD1(real_RFRD1),
        .real_RFRD2(real_RFRD2),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Both inputs all zeros (Equal)", test_num);
            real_RFRD1 = 32'h00000000;
            real_RFRD2 = 32'h00000000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Both inputs all ones (Equal)", test_num);
            real_RFRD1 = 32'hFFFFFFFF;
            real_RFRD2 = 32'hFFFFFFFF;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mismatch at LSB (Unequal)", test_num);
            real_RFRD1 = 32'h00000001;
            real_RFRD2 = 32'h00000000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mismatch at MSB (Unequal)", test_num);
            real_RFRD1 = 32'h80000000;
            real_RFRD2 = 32'h00000000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Hex Pattern Match (Equal)", test_num);
            real_RFRD1 = 32'hDEADBEEF;
            real_RFRD2 = 32'hDEADBEEF;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Hex Pattern Mismatch (Unequal)", test_num);
            real_RFRD1 = 32'hDEADBEEF;
            real_RFRD2 = 32'hDEADBE0F;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bits Match (Equal)", test_num);
            real_RFRD1 = 32'hAAAAAAAA;
            real_RFRD2 = 32'hAAAAAAAA;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bit Inversion (Unequal)", test_num);
            real_RFRD1 = 32'h55555555;
            real_RFRD2 = 32'hAAAAAAAA;
            #1;

            check_outputs(1'b0);
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
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: zero=%b",
                         zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: zero=%b",
                         expected_zero);
                $display("  Got:      zero=%b",
                         zero);
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
