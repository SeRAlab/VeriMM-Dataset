`timescale 1ns/1ps

module dfs_tree_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] node_value;
    reg rst;
    reg start;
    wire [3:0] current_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dfs_tree dut (
        .clk(clk),
        .node_value(node_value),
        .rst(rst),
        .start(start),
        .current_value(current_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            node_value = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running testcase001: Basic Start and Root Visit...");
            reset_dut();

            @(posedge clk);
            start = 1;
            node_value = 4'hA;
            @(posedge clk);
            start = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running testcase002: Sequential Traversal...");
            reset_dut();

            @(posedge clk);
            start = 1;
            node_value = 4'h1;
            @(posedge clk);
            start = 0;
            node_value = 4'h2;
            @(posedge clk);
            node_value = 4'h3;
            @(posedge clk);

            repeat(1) @(posedge clk);
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running testcase003: Reset during Operation...");
            reset_dut();

            @(posedge clk);
            start = 1;
            node_value = 4'h5;
            @(posedge clk);
            start = 0;
            node_value = 4'h9;
            @(posedge clk);


            rst = 1;
            repeat(2) @(posedge clk);
            rst = 0;

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running testcase004: Start Pulse with static data...");
            reset_dut();

            node_value = 4'hE;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            repeat(3) @(posedge clk);
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running testcase005: Deep Traversal Simulation...");
            reset_dut();

            @(posedge clk);
            start = 1;
            node_value = 4'h1;
            @(posedge clk);
            start = 0;
            node_value = 4'h2;
            @(posedge clk);
            node_value = 4'h4;
            @(posedge clk);
            node_value = 4'h8;
            @(posedge clk);

            repeat(2) @(posedge clk);
            #1;

            check_outputs(4'h8);
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
        input [3:0] expected_current_value;
        begin
            if (expected_current_value === (expected_current_value ^ current_value ^ expected_current_value)) begin
                $display("PASS");
                $display("  Outputs: current_value=%h",
                         current_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_value=%h",
                         expected_current_value);
                $display("  Got:      current_value=%h",
                         current_value);
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
        $dumpvars(0,clk, node_value, rst, start, current_value);
    end

endmodule
