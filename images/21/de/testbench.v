`timescale 1ns/1ps

module dfs_tree_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [3:0] start_node;
    reg [15:0] tree;
    wire done;
    wire [3:0] visited_node;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dfs_tree dut (
        .clk(clk),
        .rst(rst),
        .start_node(start_node),
        .tree(tree),
        .done(done),
        .visited_node(visited_node)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start_node = 0;
            tree = 16'h0000;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Single Root Node (Node 0)", test_num);
            reset_dut();
            tree = 16'h0001;
            start_node = 0;
            @(posedge clk);
            wait(done === 1);
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Simple Left Path (0->1)", test_num);
            reset_dut();
            tree = 16'h0003;
            start_node = 0;
            @(posedge clk);
            wait(done === 1);
            #1;

            check_outputs(1'b1, 4'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Root with two children (0->1,2)", test_num);
            reset_dut();
            tree = 16'h0007;
            start_node = 0;
            @(posedge clk);
            wait(done === 1);
            #1;

            check_outputs(1'b1, 4'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: DFS 0->1->3->2", test_num);
            reset_dut();
            tree = 16'h000F;
            start_node = 0;
            @(posedge clk);
            wait(done === 1);
            #1;

            check_outputs(1'b1, 4'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: DFS 0->1->4->2", test_num);
            reset_dut();
            tree = 16'h0017;
            start_node = 0;
            @(posedge clk);
            wait(done === 1);
            #1;

            check_outputs(1'b1, 4'd2);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Complete 3-level tree", test_num);
            reset_dut();
            tree = 16'h007F;
            start_node = 0;
            @(posedge clk);
            wait(done === 1);
            #1;

            check_outputs(1'b1, 4'd6);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Start from Node 1", test_num);
            reset_dut();
            tree = 16'h001A;
            start_node = 4'd1;
            @(posedge clk);
            wait(done === 1);
            #1;

            check_outputs(1'b1, 4'd4);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Sparse Tree (0->2->5)", test_num);
            reset_dut();
            tree = 16'h0025;
            start_node = 0;
            @(posedge clk);
            wait(done === 1);
            #1;

            check_outputs(1'b1, 4'd5);
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
        input expected_done;
        input [3:0] expected_visited_node;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_visited_node === (expected_visited_node ^ visited_node ^ expected_visited_node)) begin
                $display("PASS");
                $display("  Outputs: done=%b, visited_node=%h",
                         done, visited_node);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, visited_node=%h",
                         expected_done, expected_visited_node);
                $display("  Got:      done=%b, visited_node=%h",
                         done, visited_node);
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
        $dumpvars(0,clk, rst, start_node, tree, done, visited_node);
    end

endmodule
