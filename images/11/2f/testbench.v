`timescale 1ns/1ps

module bfs_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset;
    reg [1:0] start_node;
    wire [3:0] order;
    wire [3:0] visited;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bfs dut (
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .start_node(start_node),
        .order(order),
        .visited(visited)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            start_node = 2'b00;
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
            $display("Test Case %0d: Start BFS from Node 0", test_num);
            reset_dut();

            start_node = 2'd0;
            enable = 1;



            repeat(5) @(posedge clk);

            enable = 0;


            #1;



            check_outputs(4'b1111, 4'b1111);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Start BFS from Node 2", test_num);
            reset_dut();

            start_node = 2'd2;
            enable = 1;

            repeat(5) @(posedge clk);

            enable = 0;

            #1;


            check_outputs(4'b1111, 4'b1111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Restart BFS after Reset", test_num);
            reset_dut();


            start_node = 2'd1;
            enable = 1;
            repeat(5) @(posedge clk);
            enable = 0;


            reset_dut();
            start_node = 2'd3;
            enable = 1;
            repeat(5) @(posedge clk);
            enable = 0;

            #1;


            check_outputs(4'b1111, 4'b1111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enable toggle check", test_num);
            reset_dut();

            start_node = 2'd0;
            enable = 0;
            repeat(2) @(posedge clk);

            enable = 1;
            repeat(5) @(posedge clk);
            enable = 0;

            #1;


            check_outputs(4'b1111, 4'b1111);
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
        input [3:0] expected_order;
        input [3:0] expected_visited;
        begin
            if (expected_order === (expected_order ^ order ^ expected_order) &&
                expected_visited === (expected_visited ^ visited ^ expected_visited)) begin
                $display("PASS");
                $display("  Outputs: order=%h, visited=%h",
                         order, visited);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: order=%h, visited=%h",
                         expected_order, expected_visited);
                $display("  Got:      order=%h, visited=%h",
                         order, visited);
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
        $dumpvars(0,clk, enable, reset, start_node, order, visited);
    end

endmodule
