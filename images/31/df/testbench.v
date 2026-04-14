`timescale 1ns/1ps

module dfs_tree_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] node_in;
    reg rst;
    reg traverse;
    wire [3:0] current_node;
    wire [15:0] stack_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dfs_tree dut (
        .clk(clk),
        .node_in(node_in),
        .rst(rst),
        .traverse(traverse),
        .current_node(current_node),
        .stack_out(stack_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        traverse = 0;
        node_in = 4'h0;
        @(posedge clk);
        #1;
        rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Single step left traversal", test_num);
        reset_dut();
        node_in = 4'h8;


        traverse = 1;
        @(posedge clk);
        #1;
        traverse = 0;

        #1;


        check_outputs(4'h7, 16'h0008);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Multiple steps to leaf node 0", test_num);
        reset_dut();
        node_in = 4'h2;


        traverse = 1;
        @(posedge clk);
        #1;

        @(posedge clk);
        #1;
        traverse = 0;


        #1;



        check_outputs(4'h0, 16'h0021);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Pop logic from node 0", test_num);
        reset_dut();
        node_in = 4'h1;


        traverse = 1;
        @(posedge clk);
        #1;

        @(posedge clk);
        #1;
        traverse = 0;


        #1;



        check_outputs(4'h2, 16'h0000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Complex Push/Pop sequence", test_num);
        reset_dut();
        node_in = 4'h3;

        traverse = 1;
        @(posedge clk);
        #1;
        @(posedge clk);
        #1;
        @(posedge clk);
        #1;
        @(posedge clk);
        #1;
        @(posedge clk);
        #1;
        traverse = 0;



        #1;




        check_outputs(4'h1, 16'h0322);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Reset mid-operation", test_num);
        reset_dut();
        node_in = 4'h5;

        traverse = 1;
        @(posedge clk);
        #1;
        @(posedge clk);
        #1;


        rst = 1;
        @(posedge clk);
        #1;
        rst = 0;
        node_in = 4'hA;
        @(posedge clk);
        #1;


        #1;



        check_outputs(4'hA, 16'h0000);
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
        input [3:0] expected_current_node;
        input [15:0] expected_stack_out;
        begin
            if (expected_current_node === (expected_current_node ^ current_node ^ expected_current_node) &&
                expected_stack_out === (expected_stack_out ^ stack_out ^ expected_stack_out)) begin
                $display("PASS");
                $display("  Outputs: current_node=%h, stack_out=%h",
                         current_node, stack_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_node=%h, stack_out=%h",
                         expected_current_node, expected_stack_out);
                $display("  Got:      current_node=%h, stack_out=%h",
                         current_node, stack_out);
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
        $dumpvars(0,clk, node_in, rst, traverse, current_node, stack_out);
    end

endmodule
