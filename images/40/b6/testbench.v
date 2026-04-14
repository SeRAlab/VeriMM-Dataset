`timescale 1ns/1ps

module astar_search_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] cost_to_current;
    reg [1:0] current_node;
    reg [1:0] goal_node;
    reg [3:0] heuristic_estimate;
    reg rst;
    wire [1:0] next_node;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    astar_search dut (
        .clk(clk),
        .cost_to_current(cost_to_current),
        .current_node(current_node),
        .goal_node(goal_node),
        .heuristic_estimate(heuristic_estimate),
        .rst(rst),
        .next_node(next_node)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            cost_to_current = 0;
            current_node = 0;
            goal_node = 0;
            heuristic_estimate = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            current_node = 2'b00;
            goal_node = 2'b11;
            cost_to_current = 4'd0;
            heuristic_estimate = 4'd10;

            @(posedge clk);
            #1;
            $display("Testcase %0d: Start at Node 0, Target Node 3", test_num);

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            current_node = 2'b11;
            goal_node = 2'b11;
            cost_to_current = 4'd10;
            heuristic_estimate = 4'd0;

            @(posedge clk);
            #1;
            $display("Testcase %0d: Already at Goal Node", test_num);
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            current_node = 2'b01;
            goal_node = 2'b11;
            cost_to_current = 4'd2;
            heuristic_estimate = 4'd5;

            @(posedge clk);
            #1;
            $display("Testcase %0d: Moving from Intermediate Node 1 to 3", test_num);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            current_node = 2'b10;
            goal_node = 2'b11;
            cost_to_current = 4'd5;
            heuristic_estimate = 4'd1;

            @(posedge clk);
            #1;
            $display("Testcase %0d: One step away from Goal", test_num);
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            current_node = 2'b01;
            goal_node = 2'b11;
            rst = 1;

            @(posedge clk);
            #1;
            $display("Testcase %0d: Check Output during Reset", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("astar_search Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [1:0] expected_next_node;
        begin
            if (expected_next_node === (expected_next_node ^ next_node ^ expected_next_node)) begin
                $display("PASS");
                $display("  Outputs: next_node=%h",
                         next_node);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_node=%h",
                         expected_next_node);
                $display("  Got:      next_node=%h",
                         next_node);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, cost_to_current, current_node, goal_node, heuristic_estimate, rst, next_node);
    end

endmodule
