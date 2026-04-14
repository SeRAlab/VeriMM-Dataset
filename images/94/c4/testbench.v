`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg RegDst;
    reg [4:0] rd;
    reg [4:0] rt;
    wire [4:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .RegDst(RegDst),
        .rd(rd),
        .rt(rt),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running testcase001: RegDst=0, rd=5'h1F, rt=5'h00");
            RegDst = 1'b0;
            rd = 5'h1F;
            rt = 5'h00;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running testcase002: RegDst=1, rd=5'h1F, rt=5'h00");
            RegDst = 1'b1;
            rd = 5'h1F;
            rt = 5'h00;
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running testcase003: RegDst=0, rd=5'h0A, rt=5'h15");
            RegDst = 1'b0;
            rd = 5'h0A;
            rt = 5'h15;
            #1;

            check_outputs(5'h0A);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running testcase004: RegDst=1, rd=5'h0A, rt=5'h15");
            RegDst = 1'b1;
            rd = 5'h0A;
            rt = 5'h15;
            #1;

            check_outputs(5'h15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running testcase005: Boundary - All Zeros");
            RegDst = 1'b0;
            rd = 5'h00;
            rt = 5'h1F;
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Running testcase006: Boundary - All Ones");
            RegDst = 1'b1;
            rd = 5'h00;
            rt = 5'h1F;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Running testcase007: RegDst=0, rd=5'h11, rt=5'h0E");
            RegDst = 1'b0;
            rd = 5'h11;
            rt = 5'h0E;
            #1;

            check_outputs(5'h11);
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
        input [4:0] expected_Y;
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
