`timescale 1ns/1ps

module bfs_tree_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] node_in;
    reg reset;
    wire [3:0] node_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bfs_tree dut (
        .clk(clk),
        .node_in(node_in),
        .reset(reset),
        .node_out(node_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            node_in = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            node_in = 4'h1;
            @(posedge clk);
            #1;
            node_in = 0;
            repeat(2) @(posedge clk);
            $display("Testcase %0d: Root Discovery", test_num);
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            node_in = 4'h1;
            @(posedge clk); #1;
            node_in = 4'h2;
            @(posedge clk); #1;
            node_in = 4'h3;
            @(posedge clk); #1;
            node_in = 0;
            repeat(2) @(posedge clk);
            $display("Testcase %0d: Level 1 Queueing", test_num);
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            node_in = 4'h1; @(posedge clk); #1;
            node_in = 4'h2; @(posedge clk); #1;
            node_in = 4'h3; @(posedge clk); #1;
            node_in = 0;


            @(posedge clk); #1;

            $display("Testcase %0d: BFS Transition to Child", test_num);
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            node_in = 4'h1; @(posedge clk); #1;
            node_in = 4'h2; @(posedge clk); #1;
            node_in = 4'h3; @(posedge clk); #1;
            node_in = 4'h4; @(posedge clk); #1;
            node_in = 4'h5; @(posedge clk); #1;
            node_in = 0;


            repeat(4) @(posedge clk);
            #1;

            $display("Testcase %0d: Deep Tree Last Node", test_num);
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            node_in = 4'hA; @(posedge clk); #1;
            node_in = 4'hB; @(posedge clk); #1;
            reset = 1;      @(posedge clk); #1;
            reset = 0;      @(posedge clk); #1;

            $display("Testcase %0d: Reset Behavior", test_num);
            #1;

            check_outputs(4'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bfs_tree Testbench");
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
        input [3:0] expected_node_out;
        begin
            if (expected_node_out === (expected_node_out ^ node_out ^ expected_node_out)) begin
                $display("PASS");
                $display("  Outputs: node_out=%h",
                         node_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: node_out=%h",
                         expected_node_out);
                $display("  Got:      node_out=%h",
                         node_out);
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
        $dumpvars(0,clk, node_in, reset, node_out);
    end

endmodule
