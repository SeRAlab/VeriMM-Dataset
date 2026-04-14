`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg destiny;
    reg [5:0] mux_arbitro_1;
    reg reset_L;
    wire [5:0] D0_out;
    wire [5:0] D1_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .destiny(destiny),
        .mux_arbitro_1(mux_arbitro_1),
        .reset_L(reset_L),
        .D0_out(D0_out),
        .D1_out(D1_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Reset Active", test_num);
        reset_L = 1'b0;
        destiny = 1'b0;
        mux_arbitro_1 = 6'h3F;
        #1;

        check_outputs(6'h00, 6'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Direct to D0 (Data=6'h15)", test_num);
        reset_L = 1'b1;
        destiny = 1'b0;
        mux_arbitro_1 = 6'h15;
        #1;

        check_outputs(6'h15, 6'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Direct to D1 (Data=6'h2A)", test_num);
        reset_L = 1'b1;
        destiny = 1'b1;
        mux_arbitro_1 = 6'h2A;
        #1;

        check_outputs(6'h00, 6'h2A);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Reset Active while destiny is 1", test_num);
        reset_L = 1'b0;
        destiny = 1'b1;
        mux_arbitro_1 = 6'h3F;
        #1;

        check_outputs(6'h00, 6'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: All ones directed to D0", test_num);
        reset_L = 1'b1;
        destiny = 1'b0;
        mux_arbitro_1 = 6'h3F;
        #1;

        check_outputs(6'h3F, 6'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: All ones directed to D1", test_num);
        reset_L = 1'b1;
        destiny = 1'b1;
        mux_arbitro_1 = 6'h3F;
        #1;

        check_outputs(6'h00, 6'h3F);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Zero data check", test_num);
        reset_L = 1'b1;
        destiny = 1'b0;
        mux_arbitro_1 = 6'h00;
        #1;

        check_outputs(6'h00, 6'h00);
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
        input [5:0] expected_D0_out;
        input [5:0] expected_D1_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_D0_out === (expected_D0_out ^ D0_out ^ expected_D0_out) &&
                expected_D1_out === (expected_D1_out ^ D1_out ^ expected_D1_out)) begin
                $display("PASS");
                $display("  Outputs: D0_out=%h, D1_out=%h",
                         D0_out, D1_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D0_out=%h, D1_out=%h",
                         expected_D0_out, expected_D1_out);
                $display("  Got:      D0_out=%h, D1_out=%h",
                         D0_out, D1_out);
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
