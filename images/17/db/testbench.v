`timescale 1ns/1ps

module FloydWarshall_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] adjacency_matrix;
    reg clk;
    reg reset;
    wire [15:0] shortest_paths;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    FloydWarshall dut (
        .adjacency_matrix(adjacency_matrix),
        .clk(clk),
        .reset(reset),
        .shortest_paths(shortest_paths)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            adjacency_matrix = 0;
            @(posedge clk);
            #1;
            reset = 0;

            repeat (10) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset = 1;
            adjacency_matrix = 16'h8421;
            @(posedge clk);
            #1 reset = 0;
            repeat (10) @(posedge clk);
            $display("Test Case 001: Identity Matrix");
            #1;

            check_outputs(16'h8421);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset = 1;
            adjacency_matrix = 16'hC631;
            @(posedge clk);
            #1 reset = 0;
            repeat (10) @(posedge clk);
            $display("Test Case 002: Linear Chain (0->1->2->3)");
            #1;

            check_outputs(16'hF731);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset = 1;
            adjacency_matrix = 16'hC639;
            @(posedge clk);
            #1 reset = 0;
            repeat (10) @(posedge clk);
            $display("Test Case 003: Simple Cycle");
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset = 1;
            adjacency_matrix = 16'hCC33;
            @(posedge clk);
            #1 reset = 0;
            repeat (10) @(posedge clk);
            $display("Test Case 004: Disjoint Components");
            #1;

            check_outputs(16'hCC33);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset = 1;
            adjacency_matrix = 16'hF421;
            @(posedge clk);
            #1 reset = 0;
            repeat (10) @(posedge clk);
            $display("Test Case 005: Hub and Spoke (Outward)");
            #1;

            check_outputs(16'hF421);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset = 1;
            adjacency_matrix = 16'h8C99;
            @(posedge clk);
            #1 reset = 0;
            repeat (10) @(posedge clk);
            $display("Test Case 006: Hub and Spoke (Inward)");
            #1;

            check_outputs(16'h8C99);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("FloydWarshall Testbench");
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
        input [15:0] expected_shortest_paths;
        begin
            if (expected_shortest_paths === (expected_shortest_paths ^ shortest_paths ^ expected_shortest_paths)) begin
                $display("PASS");
                $display("  Outputs: shortest_paths=%h",
                         shortest_paths);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shortest_paths=%h",
                         expected_shortest_paths);
                $display("  Got:      shortest_paths=%h",
                         shortest_paths);
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
        $dumpvars(0,adjacency_matrix, clk, reset, shortest_paths);
    end

endmodule
