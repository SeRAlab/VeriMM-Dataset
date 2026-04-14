`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] DataB;
    reg [7:0] IMM;
    reg MB;
    wire [7:0] MBOUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DataB(DataB),
        .IMM(IMM),
        .MB(MB),
        .MBOUT(MBOUT)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select DataB (MB=0)", test_num);
            DataB = 8'hAA;
            IMM   = 8'h55;
            MB    = 1'b0;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select IMM (MB=1)", test_num);
            DataB = 8'hAA;
            IMM   = 8'h55;
            MB    = 1'b1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select DataB with All Zeros (MB=0)", test_num);
            DataB = 8'h00;
            IMM   = 8'hFF;
            MB    = 1'b0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select IMM with All Ones (MB=1)", test_num);
            DataB = 8'h00;
            IMM   = 8'hFF;
            MB    = 1'b1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Edge Case - Alternating Bits (MB=0)", test_num);
            DataB = 8'h3C;
            IMM   = 8'hC3;
            MB    = 1'b0;
            #1;

            check_outputs(8'h3C);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Edge Case - Alternating Bits (MB=1)", test_num);
            DataB = 8'h3C;
            IMM   = 8'hC3;
            MB    = 1'b1;
            #1;

            check_outputs(8'hC3);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Data Source 1 (MB=0)", test_num);
            DataB = 8'h12;
            IMM   = 8'h34;
            MB    = 1'b0;
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Data Source 2 (MB=1)", test_num);
            DataB = 8'h56;
            IMM   = 8'h78;
            MB    = 1'b1;
            #1;

            check_outputs(8'h78);
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
        input [7:0] expected_MBOUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_MBOUT === (expected_MBOUT ^ MBOUT ^ expected_MBOUT)) begin
                $display("PASS");
                $display("  Outputs: MBOUT=%h",
                         MBOUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MBOUT=%h",
                         expected_MBOUT);
                $display("  Got:      MBOUT=%h",
                         MBOUT);
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
