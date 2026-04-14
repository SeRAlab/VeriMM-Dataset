`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] instr1;
    reg instr1_validity;
    reg [31:0] instr2;
    wire stall;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .instr1(instr1),
        .instr1_validity(instr1_validity),
        .instr2(instr2),
        .stall(stall)
    );
    task testcase001;

        begin
            test_num = 1;

            instr2 = {OP_LW, 5'd5, 5'd4, 16'h0000};

            instr1 = {OP_RTYPE, 5'd2, 5'd3, 5'd1, 5'd0, 6'h20};
            instr1_validity = 1'b1;

            $display("Test %0d: No dependency (LW writing R4, ADD using R2,R3)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;

            instr2 = {OP_LW, 5'd5, 5'd4, 16'h0000};

            instr1 = {OP_RTYPE, 5'd4, 5'd3, 5'd1, 5'd0, 6'h20};
            instr1_validity = 1'b0;

            $display("Test %0d: Dependency exists but instr1_validity is 0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;

            instr2 = {OP_LW, 5'd10, 5'd8, 16'h0004};

            instr1 = {OP_RTYPE, 5'd8, 5'd2, 5'd12, 5'd0, 6'h22};
            instr1_validity = 1'b1;

            $display("Test %0d: Dependency on rs (instr2.rt == instr1.rs)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;

            instr2 = {OP_LW, 5'd10, 5'd8, 16'h0004};

            instr1 = {OP_RTYPE, 5'd2, 5'd8, 5'd12, 5'd0, 6'h20};
            instr1_validity = 1'b1;

            $display("Test %0d: Dependency on rt (instr2.rt == instr1.rt)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;

            instr2 = {OP_RTYPE, 5'd1, 5'd2, 5'd8, 5'd0, 6'h20};

            instr1 = {OP_RTYPE, 5'd8, 5'd3, 5'd12, 5'd0, 6'h20};
            instr1_validity = 1'b1;

            $display("Test %0d: Dependency exists but instr2 is R-type (No Load-Use Hazard)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;

            instr2 = {OP_LW, 5'd5, 5'd4, 16'h0000};

            instr1 = {OP_SW, 5'd10, 5'd4, 16'h0000};
            instr1_validity = 1'b1;

            $display("Test %0d: LW followed by SW using same register", test_num);
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
        input expected_stall;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_stall === (expected_stall ^ stall ^ expected_stall)) begin
                $display("PASS");
                $display("  Outputs: stall=%b",
                         stall);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: stall=%b",
                         expected_stall);
                $display("  Got:      stall=%b",
                         stall);
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
