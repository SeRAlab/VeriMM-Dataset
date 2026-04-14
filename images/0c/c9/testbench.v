`timescale 1ns/1ps

module dfs_tree_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] node_value;
    reg pop;
    reg push;
    reg reset;
    wire valid;
    wire [7:0] visited_node;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dfs_tree dut (
        .clk(clk),
        .node_value(node_value),
        .pop(pop),
        .push(push),
        .reset(reset),
        .valid(valid),
        .visited_node(visited_node)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            node_value = 0;
            push = 0;
            pop = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Single Node Push/Pop", test_num);
            reset_dut();

            node_value = 8'hAA;
            push = 1;
            @(posedge clk);
            push = 0;
            @(posedge clk);

            pop = 1;
            @(posedge clk);
            pop = 0;

            #2;
            #1;

            check_outputs(1'b1, 8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: LIFO Property (Stack order)", test_num);
            reset_dut();

            node_value = 8'h11; push = 1; @(posedge clk);
            node_value = 8'h22; push = 1; @(posedge clk);
            push = 0;
            @(posedge clk);

            pop = 1; @(posedge clk);
            pop = 1; @(posedge clk);
            pop = 0;

            #2;
            #1;

            check_outputs(1'b1, 8'h11);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Simple Tree DFS (Height 1)", test_num);
            reset_dut();


            node_value = 8'h01; push = 1; @(posedge clk); push = 0; @(posedge clk);

            pop = 1; @(posedge clk); pop = 0; @(posedge clk);

            node_value = 8'h03; push = 1; @(posedge clk);
            node_value = 8'h02; push = 1; @(posedge clk); push = 0; @(posedge clk);

            pop = 1; @(posedge clk); pop = 0; @(posedge clk);

            pop = 1; @(posedge clk); pop = 0;

            #2;
            #1;

            check_outputs(1'b1, 8'h03);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Branching DFS Traversal", test_num);
            reset_dut();


            node_value = 8'h01; push = 1; @(posedge clk); push = 0; @(posedge clk);
            pop = 1; @(posedge clk); pop = 0; @(posedge clk);

            node_value = 8'h03; push = 1; @(posedge clk);
            node_value = 8'h02; push = 1; @(posedge clk); push = 0; @(posedge clk);

            pop = 1; @(posedge clk); pop = 0; @(posedge clk);

            node_value = 8'h05; push = 1; @(posedge clk);
            node_value = 8'h04; push = 1; @(posedge clk); push = 0; @(posedge clk);

            pop = 1; @(posedge clk);
            pop = 1; @(posedge clk);
            pop = 1; @(posedge clk);
            pop = 0;

            #2;
            #1;

            check_outputs(1'b1, 8'h03);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Reset mid-operation", test_num);
            reset_dut();

            node_value = 8'hFE; push = 1; @(posedge clk);
            node_value = 8'hDC; push = 1; @(posedge clk);
            push = 0; @(posedge clk);

            reset_dut();

            node_value = 8'hA5; push = 1; @(posedge clk);
            push = 0; @(posedge clk);
            pop = 1; @(posedge clk);
            pop = 0;

            #2;
            #1;

            check_outputs(1'b1, 8'hA5);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dfs_tree Testbench");
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
        input expected_valid;
        input [7:0] expected_visited_node;
        begin
            if (expected_valid === (expected_valid ^ valid ^ expected_valid) &&
                expected_visited_node === (expected_visited_node ^ visited_node ^ expected_visited_node)) begin
                $display("PASS");
                $display("  Outputs: valid=%b, visited_node=%h",
                         valid, visited_node);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: valid=%b, visited_node=%h",
                         expected_valid, expected_visited_node);
                $display("  Got:      valid=%b, visited_node=%h",
                         valid, visited_node);
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
        $dumpvars(0,clk, node_value, pop, push, reset, valid, visited_node);
    end

endmodule
