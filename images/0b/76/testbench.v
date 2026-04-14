`timescale 1ns/1ps

module dfs_tree_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] current_node;
    wire [3:0] next_node;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dfs_tree dut (
        .clk(clk),
        .current_node(current_node),
        .next_node(next_node)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            current_node = 4'd0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            current_node = 4'd0;
            @(posedge clk);
            #1;
            $display("Test %0d: Root (0) to Left Child (1)", test_num);
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            current_node = 4'd1;
            @(posedge clk);
            #1;
            $display("Test %0d: Node 1 to Left Leaf 3", test_num);
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            current_node = 4'd3;
            @(posedge clk);
            #1;
            $display("Test %0d: Leaf 3 to Sibling Leaf 4", test_num);
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            current_node = 4'd4;
            @(posedge clk);
            #1;
            $display("Test %0d: Leaf 4 to Right Subtree Root 2", test_num);
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            current_node = 4'd2;
            @(posedge clk);
            #1;
            $display("Test %0d: Node 2 to Left Child 5", test_num);
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            current_node = 4'd5;
            @(posedge clk);
            #1;
            $display("Test %0d: Leaf 5 to Sibling Leaf 6", test_num);
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            current_node = 4'd6;
            @(posedge clk);
            #1;
            $display("Test %0d: Terminal node 6 to Wrap-around/Idle", test_num);


            #1;



            check_outputs(4'd0);
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
        input [3:0] expected_next_node;
        begin
            if (expected_next_node === (expected_next_node ^ next_node ^ expected_next_node)) begin
                $display("PASS");
                $display("  Outputs: next_node=%h",
                         next_node);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_node=%h",
                         expected_next_node);
                $display("  Got:      next_node=%h",
                         next_node);
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
        $dumpvars(0,clk, current_node, next_node);
    end

endmodule
