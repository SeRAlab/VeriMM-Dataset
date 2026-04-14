`timescale 1ns/1ps

module bfs_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg start;
    reg [2:0] start_node;
    wire done;
    wire [15:0] traversal_order;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bfs dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .start_node(start_node),
        .done(done),
        .traversal_order(traversal_order)
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
            start_node = 3'b000;
            repeat (2) @(posedge clk);
            #1 rst = 0;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: BFS starting from Node 0", test_num);
            reset_dut();

            start_node = 3'd0;
            start = 1;
            @(posedge clk);
            start = 0;


            wait(done == 1'b1);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 16'h0123);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: BFS starting from Node 3", test_num);
            reset_dut();

            start_node = 3'd3;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1'b1);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 16'h3120);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: BFS starting from Node 1", test_num);
            reset_dut();

            start_node = 3'd1;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1'b1);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 16'h1032);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: BFS starting from Node 2", test_num);
            reset_dut();

            start_node = 3'd2;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1'b1);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 16'h2031);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset during operation", test_num);
            reset_dut();

            start_node = 3'd0;
            start = 1;
            @(posedge clk);
            start = 0;


            repeat (2) @(posedge clk);
            rst = 1;
            @(posedge clk);
            rst = 0;


            #1;



            check_outputs(1'b0, 16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bfs Testbench");
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
        input expected_done;
        input [15:0] expected_traversal_order;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_traversal_order === (expected_traversal_order ^ traversal_order ^ expected_traversal_order)) begin
                $display("PASS");
                $display("  Outputs: done=%b, traversal_order=%h",
                         done, traversal_order);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, traversal_order=%h",
                         expected_done, expected_traversal_order);
                $display("  Got:      done=%b, traversal_order=%h",
                         done, traversal_order);
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
        $dumpvars(0,clk, rst, start, start_node, done, traversal_order);
    end

endmodule
