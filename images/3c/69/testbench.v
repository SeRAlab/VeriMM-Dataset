`timescale 1ns/1ps

module AStarSearch_tb;

    // Testbench signals (sequential circuit)
    reg add_node;
    reg clk;
    reg [7:0] g_cost;
    reg [7:0] h_cost;
    reg move_node;
    reg rst;
    wire [7:0] closed_list_count;
    wire [7:0] f_cost;
    wire [7:0] open_list_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AStarSearch dut (
        .add_node(add_node),
        .clk(clk),
        .g_cost(g_cost),
        .h_cost(h_cost),
        .move_node(move_node),
        .rst(rst),
        .closed_list_count(closed_list_count),
        .f_cost(f_cost),
        .open_list_count(open_list_count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        add_node = 0;
        move_node = 0;
        g_cost = 0;
        h_cost = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        $display("\nRunning testcase001: Add nodes to open list...");
        reset_dut();


        @(posedge clk);
        g_cost = 8'd10; h_cost = 8'd5; add_node = 1;
        @(posedge clk);
        g_cost = 8'd15; h_cost = 8'd10; add_node = 1;
        @(posedge clk);
        g_cost = 8'd20; h_cost = 8'd20; add_node = 1;
        @(posedge clk);
        add_node = 0;


        #1;



        check_outputs(8'd0, 8'd40, 8'd3);
    end
        endtask

    task testcase002;

    begin
        $display("\nRunning testcase002: Move nodes to closed list...");
        reset_dut();


        repeat(5) begin
            @(posedge clk);
            add_node = 1;
        end
        @(posedge clk);
        add_node = 0;


        repeat(2) begin
            @(posedge clk);
            move_node = 1;
        end
        @(posedge clk);
        move_node = 0;


        #1;



        check_outputs(8'd2, 8'd0, 8'd3);
    end
        endtask

    task testcase003;

    begin
        $display("\nRunning testcase003: Verify F-Cost logic (g+h)...");
        reset_dut();

        @(posedge clk);
        g_cost = 8'd50;
        h_cost = 8'd75;


        @(posedge clk);


        #1;



        check_outputs(8'd0, 8'd125, 8'd0);
    end
        endtask

    task testcase004;

    begin
        $display("\nRunning testcase004: Complex sequence of operations...");
        reset_dut();


        @(posedge clk); add_node = 1; g_cost = 5; h_cost = 5;
        @(posedge clk); add_node = 1;



        @(posedge clk); add_node = 0; move_node = 1;
        @(posedge clk); move_node = 0;


        repeat(4) begin
            @(posedge clk); add_node = 1;
        end
        @(posedge clk); add_node = 0;


        @(posedge clk); move_node = 1;
        @(posedge clk); move_node = 0;


        #1;



        check_outputs(8'd2, 8'd10, 8'd4);
    end
        endtask

    task testcase005;

    begin
        $display("\nRunning testcase005: Reset mid-operation...");
        reset_dut();

        repeat(10) @(posedge clk) add_node = 1;
        @(posedge clk) add_node = 0;


        @(posedge clk) rst = 1;
        @(posedge clk) rst = 0;

        #1;


        check_outputs(8'd0, 8'd0, 8'd0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("AStarSearch Testbench");
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
        input [7:0] expected_closed_list_count;
        input [7:0] expected_f_cost;
        input [7:0] expected_open_list_count;
        begin
            if (expected_closed_list_count === (expected_closed_list_count ^ closed_list_count ^ expected_closed_list_count) &&
                expected_f_cost === (expected_f_cost ^ f_cost ^ expected_f_cost) &&
                expected_open_list_count === (expected_open_list_count ^ open_list_count ^ expected_open_list_count)) begin
                $display("PASS");
                $display("  Outputs: closed_list_count=%h, f_cost=%h, open_list_count=%h",
                         closed_list_count, f_cost, open_list_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: closed_list_count=%h, f_cost=%h, open_list_count=%h",
                         expected_closed_list_count, expected_f_cost, expected_open_list_count);
                $display("  Got:      closed_list_count=%h, f_cost=%h, open_list_count=%h",
                         closed_list_count, f_cost, open_list_count);
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
        $dumpvars(0,add_node, clk, g_cost, h_cost, move_node, rst, closed_list_count, f_cost, open_list_count);
    end

endmodule
