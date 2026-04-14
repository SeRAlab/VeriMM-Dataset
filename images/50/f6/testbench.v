`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] ALUOP;
    reg [5:0] func;
    wire [5:0] alu_control_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUOP(ALUOP),
        .func(func),
        .alu_control_out(alu_control_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: ALUOP is not 6'b111111 (ALUOP=0, func=1)", test_num);
            ALUOP = 6'b000000;
            func = 6'b000001;
            #1;

            check_outputs(6'b000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: ALUOP is 6'b111111 (ALUOP=3F, func=2A)", test_num);
            ALUOP = 6'b111111;
            func = 6'h2A;
            #1;

            check_outputs(6'h2A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: ALUOP is not 6'b111111 (ALUOP=15, func=3F)", test_num);
            ALUOP = 6'h15;
            func = 6'b111111;
            #1;

            check_outputs(6'h15);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: ALUOP is 6'b111111 (ALUOP=3F, func=00)", test_num);
            ALUOP = 6'b111111;
            func = 6'b000000;
            #1;

            check_outputs(6'b000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: ALUOP is 6'b111110 (ALUOP=3E, func=3F)", test_num);
            ALUOP = 6'b111110;
            func = 6'b111111;
            #1;

            check_outputs(6'b111110);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Both ALUOP and func are 6'b111111", test_num);
            ALUOP = 6'b111111;
            func = 6'b111111;
            #1;

            check_outputs(6'b111111);
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
        input [5:0] expected_alu_control_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_alu_control_out === (expected_alu_control_out ^ alu_control_out ^ expected_alu_control_out)) begin
                $display("PASS");
                $display("  Outputs: alu_control_out=%h",
                         alu_control_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alu_control_out=%h",
                         expected_alu_control_out);
                $display("  Got:      alu_control_out=%h",
                         alu_control_out);
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
