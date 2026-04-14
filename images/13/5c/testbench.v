`timescale 1ns/1ps

module bfs_tree_traversal_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [15:0] tree_nodes;
    wire [3:0] bfs_output;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bfs_tree_traversal dut (
        .clk(clk),
        .rst(rst),
        .tree_nodes(tree_nodes),
        .bfs_output(bfs_output),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            tree_nodes = 16'h1234;
            reset_dut();
            wait(done === 1);
            @(posedge clk);
            $display("Test Case %0d: Sequential values 1, 2, 3, 4", test_num);
            #1;

            check_outputs(4'h4, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            tree_nodes = 16'hFEDC;
            reset_dut();
            wait(done === 1);
            @(posedge clk);
            $display("Test Case %0d: Descending values F, E, D, C", test_num);
            #1;

            check_outputs(4'hC, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            tree_nodes = 16'hAAAA;
            reset_dut();
            wait(done === 1);
            @(posedge clk);
            $display("Test Case %0d: Identical values A, A, A, A", test_num);
            #1;

            check_outputs(4'hA, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            tree_nodes = 16'h5050;
            reset_dut();
            wait(done === 1);
            @(posedge clk);
            $display("Test Case %0d: Alternating values 5, 0, 5, 0", test_num);
            #1;

            check_outputs(4'h0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            tree_nodes = 16'hB0EF;
            reset_dut();
            wait(done === 1);
            @(posedge clk);
            $display("Test Case %0d: Mixed values B, 0, E, F", test_num);
            #1;

            check_outputs(4'hF, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bfs_tree_traversal Testbench");
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
        input [3:0] expected_bfs_output;
        input expected_done;
        begin
            if (expected_bfs_output === (expected_bfs_output ^ bfs_output ^ expected_bfs_output) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: bfs_output=%h, done=%b",
                         bfs_output, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bfs_output=%h, done=%b",
                         expected_bfs_output, expected_done);
                $display("  Got:      bfs_output=%h, done=%b",
                         bfs_output, done);
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
        $dumpvars(0,clk, rst, tree_nodes, bfs_output, done);
    end

endmodule
