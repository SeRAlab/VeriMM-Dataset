`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] ADD;
    reg D_IN;
    reg NEG;
    wire [4:0] CORR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ADD(ADD),
        .D_IN(D_IN),
        .NEG(NEG),
        .CORR(CORR)
    );
    task testcase001;

        begin
            test_num = 1;
            ADD = 5'd7;
            D_IN = 1'b0;
            NEG = 1'b0;
            #1;

            check_outputs(5'd7);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            ADD = 5'd13;
            D_IN = 1'b0;
            NEG = 1'b0;
            #1;

            check_outputs(5'd19);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            ADD = 5'd16;
            D_IN = 1'b0;
            NEG = 1'b0;
            #1;

            check_outputs(5'd22);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            ADD = 5'd10;
            D_IN = 1'b0;
            NEG = 1'b0;
            #1;

            check_outputs(5'd16);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            ADD = 5'd18;
            D_IN = 1'b1;
            NEG = 1'b1;
            #1;

            check_outputs(5'd18);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            ADD = 5'd14;
            D_IN = 1'b0;
            NEG = 1'b1;
            #1;

            check_outputs(5'd8);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            ADD = 5'd6;
            D_IN = 1'b0;
            NEG = 1'b1;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            ADD = 5'd2;
            D_IN = 1'b0;
            NEG = 1'b1;
            #1;

            check_outputs(5'd28);
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
        input [4:0] expected_CORR;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CORR === (expected_CORR ^ CORR ^ expected_CORR)) begin
                $display("PASS");
                $display("  Outputs: CORR=%h",
                         CORR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CORR=%h",
                         expected_CORR);
                $display("  Got:      CORR=%h",
                         CORR);
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
