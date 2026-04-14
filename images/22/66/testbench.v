`timescale 1ns/1ps

module DFS_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [2:0] start_vertex;
    wire done;
    wire [2:0] visited_vertex;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DFS dut (
        .clk(clk),
        .reset(reset),
        .start_vertex(start_vertex),
        .done(done),
        .visited_vertex(visited_vertex)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start_vertex = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Start from Vertex 0", test_num);
            reset_dut();
            start_vertex = 3'd0;


            while (!done) @(posedge clk);


            #1 #1;
 check_outputs(1'b1, 3'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Start from Vertex 2", test_num);
            reset_dut();
            start_vertex = 3'd2;

            while (!done) @(posedge clk);


            #1 #1;
 check_outputs(1'b1, 3'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Start from Isolated Vertex 7", test_num);
            reset_dut();
            start_vertex = 3'd7;

            while (!done) @(posedge clk);


            #1 #1;
 check_outputs(1'b1, 3'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Start from Vertex 4", test_num);
            reset_dut();
            start_vertex = 3'd4;

            while (!done) @(posedge clk);


            #1 #1;
 check_outputs(1'b1, 3'd6);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DFS Testbench");
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
        input [2:0] expected_visited_vertex;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_visited_vertex === (expected_visited_vertex ^ visited_vertex ^ expected_visited_vertex)) begin
                $display("PASS");
                $display("  Outputs: done=%b, visited_vertex=%h",
                         done, visited_vertex);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, visited_vertex=%h",
                         expected_done, expected_visited_vertex);
                $display("  Got:      done=%b, visited_vertex=%h",
                         done, visited_vertex);
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
        $dumpvars(0,clk, reset, start_vertex, done, visited_vertex);
    end

endmodule
