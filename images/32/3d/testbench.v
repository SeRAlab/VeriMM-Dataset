`timescale 1ns/1ps

module AStar_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] cost;
    reg [7:0] current_state;
    reg [7:0] heuristic;
    wire [7:0] next_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AStar dut (
        .cost(cost),
        .current_state(current_state),
        .heuristic(heuristic),
        .next_state(next_state)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Addition", test_num);
        current_state = 8'd10;
        cost = 8'd20;
        heuristic = 8'd30;
        #1;

        check_outputs(8'd60);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All Zeros", test_num);
        current_state = 8'h00;
        cost = 8'h00;
        heuristic = 8'h00;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary Overflow (Result = 257 -> 1)", test_num);
        current_state = 8'd255;
        cost = 8'd1;
        heuristic = 8'd1;
        #1;

        check_outputs(8'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mid-range Values", test_num);
        current_state = 8'h80;
        cost = 8'h40;
        heuristic = 8'h20;
        #1;

        check_outputs(8'hE0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Large Overflow (Result = 300 -> 44)", test_num);
        current_state = 8'd100;
        cost = 8'd100;
        heuristic = 8'd100;
        #1;

        check_outputs(8'd44);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Maximum Inputs (Result = 765 -> 253)", test_num);
        current_state = 8'hFF;
        cost = 8'hFF;
        heuristic = 8'hFF;
        #1;

        check_outputs(8'd253);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: One High Input", test_num);
        current_state = 8'd0;
        cost = 8'd200;
        heuristic = 8'd0;
        #1;

        check_outputs(8'd200);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("AStar Testbench");
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
        input [7:0] expected_next_state;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_next_state === (expected_next_state ^ next_state ^ expected_next_state)) begin
                $display("PASS");
                $display("  Outputs: next_state=%h",
                         next_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_state=%h",
                         expected_next_state);
                $display("  Got:      next_state=%h",
                         next_state);
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
