`timescale 1ns/1ps

module DFS_BinaryTree_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] index;
    reg [14:0] tree;
    wire done;
    wire [3:0] visited_node;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DFS_BinaryTree dut (
        .clk(clk),
        .index(index),
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
            rst_n = 0;
            index = 0;
            tree = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: Root Only", test_num);
            tree = 15'h0001;
            index = 0;
            wait(done == 0);
            wait(done == 1);
            #1;
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: Left-Skewed Path", test_num);

            tree = 15'h008B;
            index = 0;
            wait(done == 0);
            wait(done == 1);
            #1;
            #1;

            check_outputs(1'b1, 4'd7);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: Right-Skewed Path", test_num);

            tree = 15'h4045;
            index = 0;
            wait(done == 0);
            wait(done == 1);
            #1;
            #1;

            check_outputs(1'b1, 4'd14);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: Balanced 3-Level Tree", test_num);
            tree = 15'h007F;
            index = 0;
            wait(done == 0);
            wait(done == 1);
            #1;

            #1;


            check_outputs(1'b1, 4'd6);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: Full 15-Node Tree", test_num);
            tree = 15'h7FFF;
            index = 0;
            wait(done == 0);
            wait(done == 1);
            #1;

            #1;


            check_outputs(1'b1, 4'd14);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: Subtree DFS from Index 1", test_num);
            tree = 15'h7FFF;
            index = 1;
            wait(done == 0);
            wait(done == 1);
            #1;

            #1;


            check_outputs(1'b1, 4'd10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DFS_BinaryTree Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        $dumpvars(0,clk, index, tree, done, visited_node);
    end

endmodule
