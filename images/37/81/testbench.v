`timescale 1ns/1ps

module dfs_traversal_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] index;
    reg rst;
    wire [7:0] node_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dfs_traversal dut (
        .clk(clk),
        .index(index),
        .rst(rst),
        .node_value(node_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            index = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            index = 3'd0;
            @(posedge clk);
            #1;
            $display("Testcase 001: Checking Root (Index 0)");


            #1;



            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            index = 3'd1;
            @(posedge clk);
            #1;
            $display("Testcase 002: Checking Left Child (Index 1)");
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            index = 3'd3;
            @(posedge clk);
            #1;
            $display("Testcase 003: Checking Left-Left Leaf (Index 3)");
            #1;

            check_outputs(8'h03);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            index = 3'd4;
            @(posedge clk);
            #1;
            $display("Testcase 004: Checking Left-Right Leaf (Index 4)");
            #1;

            check_outputs(8'h04);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            index = 3'd2;
            @(posedge clk);
            #1;
            $display("Testcase 005: Checking Right Child (Index 2)");
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            index = 3'd5;
            @(posedge clk);
            #1;
            $display("Testcase 006: Checking Right-Left Leaf (Index 5)");
            #1;

            check_outputs(8'h05);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            index = 3'd6;
            @(posedge clk);
            #1;
            $display("Testcase 007: Checking Right-Right Leaf (Index 6)");
            #1;

            check_outputs(8'h06);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dfs_traversal Testbench");
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
        input [7:0] expected_node_value;
        begin
            if (expected_node_value === (expected_node_value ^ node_value ^ expected_node_value)) begin
                $display("PASS");
                $display("  Outputs: node_value=%h",
                         node_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: node_value=%h",
                         expected_node_value);
                $display("  Got:      node_value=%h",
                         node_value);
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
        $dumpvars(0,clk, index, rst, node_value);
    end

endmodule
