`timescale 1ns/1ps

module Prim_MST_tb;

    // Testbench signals (sequential circuit)
    reg [24:0] adj_matrix;
    reg clk;
    reg rst;
    wire done;
    wire [24:0] mst_edges;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Prim_MST dut (
        .adj_matrix(adj_matrix),
        .clk(clk),
        .rst(rst),
        .done(done),
        .mst_edges(mst_edges)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            adj_matrix = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Star Graph (Center 0)", test_num);
            reset_dut();


            adj_matrix = 25'b00001_00001_00001_00001_11110;
            @(posedge clk);
            wait(done == 1);
            #10;
            #1;

            check_outputs(1'b1, 25'b00001_00001_00001_00001_11110);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Path Graph (0-1-2-3-4)", test_num);
            reset_dut();

            adj_matrix = 25'b01000_10100_01010_00101_00010;
            @(posedge clk);
            wait(done == 1);
            #10;
            #1;

            check_outputs(1'b1, 25'b01000_10100_01010_00101_00010);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Binary Tree Graph", test_num);
            reset_dut();

            adj_matrix = 25'b01000_01000_00001_11001_00110;
            @(posedge clk);
            wait(done == 1);
            #10;
            #1;

            check_outputs(1'b1, 25'b01000_01000_00001_11001_00110);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Forked Tree (Center 3)", test_num);
            reset_dut();

            adj_matrix = 25'b01000_10111_01000_01000_01000;
            @(posedge clk);
            wait(done == 1);
            #10;
            #1;

            check_outputs(1'b1, 25'b01000_10111_01000_01000_01000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Prim_MST Testbench");
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
        input [24:0] expected_mst_edges;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_mst_edges === (expected_mst_edges ^ mst_edges ^ expected_mst_edges)) begin
                $display("PASS");
                $display("  Outputs: done=%b, mst_edges=%h",
                         done, mst_edges);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, mst_edges=%h",
                         expected_done, expected_mst_edges);
                $display("  Got:      done=%b, mst_edges=%h",
                         done, mst_edges);
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
        $dumpvars(0,adj_matrix, clk, rst, done, mst_edges);
    end

endmodule
