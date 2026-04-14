`timescale 1ns/1ps

module bfs_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [3:0] start_node;
    reg start_traversal;
    wire traversal_done;
    wire [3:0] visited_node;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bfs dut (
        .clk(clk),
        .reset(reset),
        .start_node(start_node),
        .start_traversal(start_traversal),
        .traversal_done(traversal_done),
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
            start_traversal = 0;
            start_node = 4'd0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: BFS starting from Root (Node 0)", test_num);
            reset_dut();

            start_node = 4'd0;
            start_traversal = 1;
            @(posedge clk);
            #1;
            start_traversal = 0;


            wait(traversal_done == 1);
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 4'd14);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: BFS starting from Node 1", test_num);
            reset_dut();

            start_node = 4'd1;
            start_traversal = 1;
            @(posedge clk);
            #1;
            start_traversal = 0;

            wait(traversal_done == 1);
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 4'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: BFS starting from Node 2", test_num);
            reset_dut();

            start_node = 4'd2;
            start_traversal = 1;
            @(posedge clk);
            #1;
            start_traversal = 0;

            wait(traversal_done == 1);
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 4'd14);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: BFS starting from Node 3", test_num);
            reset_dut();

            start_node = 4'd3;
            start_traversal = 1;
            @(posedge clk);
            #1;
            start_traversal = 0;

            wait(traversal_done == 1);
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 4'd8);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: BFS starting from Leaf Node 14", test_num);
            reset_dut();

            start_node = 4'd14;
            start_traversal = 1;
            @(posedge clk);
            #1;
            start_traversal = 0;

            wait(traversal_done == 1);
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 4'd14);
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
        input expected_traversal_done;
        input [3:0] expected_visited_node;
        begin
            if (expected_traversal_done === (expected_traversal_done ^ traversal_done ^ expected_traversal_done) &&
                expected_visited_node === (expected_visited_node ^ visited_node ^ expected_visited_node)) begin
                $display("PASS");
                $display("  Outputs: traversal_done=%b, visited_node=%h",
                         traversal_done, visited_node);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: traversal_done=%b, visited_node=%h",
                         expected_traversal_done, expected_visited_node);
                $display("  Got:      traversal_done=%b, visited_node=%h",
                         traversal_done, visited_node);
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
        $dumpvars(0,clk, reset, start_node, start_traversal, traversal_done, visited_node);
    end

endmodule
