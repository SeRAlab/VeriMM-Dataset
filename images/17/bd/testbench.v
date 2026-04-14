`timescale 1ns/1ps

module dfs_tree_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [3:0] root_node;
    reg rst;
    wire done;
    wire [3:0] visited_node;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dfs_tree dut (
        .clk(clk),
        .enable(enable),
        .root_node(root_node),
        .rst(rst),
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
            enable = 0;
            root_node = 4'b0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Full Tree DFS starting at Node 1", test_num);
            reset_dut();

            root_node = 4'd1;
            enable = 1;
            @(posedge clk);
            #1 enable = 0;


            wait(done == 1);


            #1;



            check_outputs(1'b1, 4'd7);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sub-tree DFS starting at Node 2", test_num);
            reset_dut();

            root_node = 4'd2;
            enable = 1;
            @(posedge clk);
            #1 enable = 0;

            wait(done == 1);


            #1;



            check_outputs(1'b1, 4'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Leaf Node DFS starting at Node 4", test_num);
            reset_dut();

            root_node = 4'd4;
            enable = 1;
            @(posedge clk);
            #1 enable = 0;

            wait(done == 1);


            #1;



            check_outputs(1'b1, 4'd4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sub-tree DFS starting at Node 3", test_num);
            reset_dut();

            root_node = 4'd3;
            enable = 1;
            @(posedge clk);
            #1 enable = 0;

            wait(done == 1);


            #1;



            check_outputs(1'b1, 4'd7);
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
        $dumpvars(0,clk, enable, root_node, rst, done, visited_node);
    end

endmodule
