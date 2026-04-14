`timescale 1ns/1ps

module a_star_heuristic_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] g_cost;
    reg [3:0] h_cost;
    wire [4:0] f_cost;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    a_star_heuristic dut (
        .g_cost(g_cost),
        .h_cost(h_cost),
        .f_cost(f_cost)
    );
    task testcase001;

    begin
        test_num = 1;
        g_cost = 4'd0;
        h_cost = 4'd0;
        $display("Testcase %0d: Zero Inputs (0 + 0)", test_num);
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        g_cost = 4'd1;
        h_cost = 4'd1;
        $display("Testcase %0d: Minimum Non-Zero (1 + 1)", test_num);
        #1;

        check_outputs(5'd2);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        g_cost = 4'd5;
        h_cost = 4'd3;
        $display("Testcase %0d: Simple addition (5 + 3)", test_num);
        #1;

        check_outputs(5'd8);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        g_cost = 4'd8;
        h_cost = 4'd7;
        $display("Testcase %0d: Boundary of 4-bit sum (8 + 7)", test_num);
        #1;

        check_outputs(5'd15);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        g_cost = 4'd10;
        h_cost = 4'd6;
        $display("Testcase %0d: Sum exceeding 4 bits (10 + 6)", test_num);
        #1;

        check_outputs(5'd16);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        g_cost = 4'd12;
        h_cost = 4'd13;
        $display("Testcase %0d: High values (12 + 13)", test_num);
        #1;

        check_outputs(5'd25);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        g_cost = 4'd15;
        h_cost = 4'd15;
        $display("Testcase %0d: Maximum values (15 + 15)", test_num);
        #1;

        check_outputs(5'd30);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("a_star_heuristic Testbench");
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
        input [4:0] expected_f_cost;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_f_cost === (expected_f_cost ^ f_cost ^ expected_f_cost)) begin
                $display("PASS");
                $display("  Outputs: f_cost=%h",
                         f_cost);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: f_cost=%h",
                         expected_f_cost);
                $display("  Got:      f_cost=%h",
                         f_cost);
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
