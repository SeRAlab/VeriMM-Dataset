`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] Comp_Code;
    reg LT;
    reg ZF;
    wire Branch;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Comp_Code(Comp_Code),
        .LT(LT),
        .ZF(ZF),
        .Branch(Branch)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Comp_Code=00, ZF=1, LT=0 (Expect Branch=1)", test_num);
            Comp_Code = 2'b00; ZF = 1; LT = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Comp_Code=00, ZF=0, LT=1 (Expect Branch=0)", test_num);
            Comp_Code = 2'b00; ZF = 0; LT = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Comp_Code=01, ZF=0, LT=0 (Expect Branch=1)", test_num);
            Comp_Code = 2'b01; ZF = 0; LT = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Comp_Code=01, ZF=1, LT=1 (Expect Branch=0)", test_num);
            Comp_Code = 2'b01; ZF = 1; LT = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Comp_Code=10, ZF=0, LT=1 (Expect Branch=1)", test_num);
            Comp_Code = 2'b10; ZF = 0; LT = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Comp_Code=10, ZF=1, LT=0 (Expect Branch=0)", test_num);
            Comp_Code = 2'b10; ZF = 1; LT = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Comp_Code=11, ZF=1, LT=1 (Expect Branch=1 - ZF is true)", test_num);
            Comp_Code = 2'b11; ZF = 1; LT = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Comp_Code=11, ZF=0, LT=0 (Expect Branch=1 - LT is false)", test_num);
            Comp_Code = 2'b11; ZF = 0; LT = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Comp_Code=11, ZF=0, LT=1 (Expect Branch=0 - ZF false AND LT true)", test_num);
            Comp_Code = 2'b11; ZF = 0; LT = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Comp_Code=11, ZF=1, LT=0 (Expect Branch=1 - Both conditions met)", test_num);
            Comp_Code = 2'b11; ZF = 1; LT = 0;
            #1;

            check_outputs(1'b1);
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
        input expected_Branch;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Branch === (expected_Branch ^ Branch ^ expected_Branch)) begin
                $display("PASS");
                $display("  Outputs: Branch=%b",
                         Branch);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Branch=%b",
                         expected_Branch);
                $display("  Got:      Branch=%b",
                         Branch);
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
