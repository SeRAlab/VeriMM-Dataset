`timescale 1ns/1ps

module DFS_BinaryTree_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] root_value;
    reg rst;
    wire done;
    wire [3:0] visited_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DFS_BinaryTree dut (
        .clk(clk),
        .root_value(root_value),
        .rst(rst),
        .done(done),
        .visited_value(visited_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            root_value = 4'd0;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: DFS starting from Root 1 (Full Tree)", test_num);
            reset_dut();

            root_value = 4'd1;



            fork : timeout_block
                begin
                    wait(done == 1'b1);
                end
                begin
                    repeat (100) @(posedge clk);
                end
            join

            #1;
            #1;

            check_outputs(1'b1, 4'd7);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: DFS starting from Node 2 (Left Subtree)", test_num);
            reset_dut();

            root_value = 4'd2;

            fork : timeout_block
                begin
                    wait(done == 1'b1);
                end
                begin
                    repeat (100) @(posedge clk);
                end
            join

            #1;
            #1;

            check_outputs(1'b1, 4'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: DFS starting from Leaf Node 4", test_num);
            reset_dut();

            root_value = 4'd4;

            fork : timeout_block
                begin
                    wait(done == 1'b1);
                end
                begin
                    repeat (50) @(posedge clk);
                end
            join

            #1;
            #1;

            check_outputs(1'b1, 4'd4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: DFS starting from Node 3 (Right Subtree)", test_num);
            reset_dut();

            root_value = 4'd3;

            fork : timeout_block
                begin
                    wait(done == 1'b1);
                end
                begin
                    repeat (100) @(posedge clk);
                end
            join

            #1;
            #1;

            check_outputs(1'b1, 4'd7);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: DFS starting from Leaf Node 5", test_num);
            reset_dut();

            root_value = 4'd5;

            fork : timeout_block
                begin
                    wait(done == 1'b1);
                end
                begin
                    repeat (50) @(posedge clk);
                end
            join

            #1;
            #1;

            check_outputs(1'b1, 4'd5);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: DFS starting from Leaf Node 6", test_num);
            reset_dut();

            root_value = 4'd6;

            fork : timeout_block
                begin
                    wait(done == 1'b1);
                end
                begin
                    repeat (50) @(posedge clk);
                end
            join

            #1;
            #1;

            check_outputs(1'b1, 4'd6);
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
        input [3:0] expected_visited_value;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_visited_value === (expected_visited_value ^ visited_value ^ expected_visited_value)) begin
                $display("PASS");
                $display("  Outputs: done=%b, visited_value=%h",
                         done, visited_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, visited_value=%h",
                         expected_done, expected_visited_value);
                $display("  Got:      done=%b, visited_value=%h",
                         done, visited_value);
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
        $dumpvars(0,clk, root_value, rst, done, visited_value);
    end

endmodule
