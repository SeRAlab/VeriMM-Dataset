`timescale 1ns/1ps

module AStarFSM_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] current_node;
    reg [7:0] g_cost;
    reg [3:0] goal_node;
    reg [7:0] h_cost;
    reg reset;
    reg valid;
    wire [7:0] f_cost;
    wire [3:0] next_node;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AStarFSM dut (
        .clk(clk),
        .current_node(current_node),
        .g_cost(g_cost),
        .goal_node(goal_node),
        .h_cost(h_cost),
        .reset(reset),
        .valid(valid),
        .f_cost(f_cost),
        .next_node(next_node)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            valid = 0;
            current_node = 0;
            g_cost = 0;
            goal_node = 0;
            h_cost = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Start node to neighbor calculation", test_num);
            reset_dut();
            current_node = 4'h1;
            goal_node    = 4'h8;
            g_cost       = 8'd10;
            h_cost       = 8'd25;
            valid        = 1;
            @(posedge clk);
            valid        = 0;


            repeat(4) @(posedge clk);



            #1;




            check_outputs(8'd35, 4'h8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Goal node reached", test_num);
            reset_dut();
            current_node = 4'h5;
            goal_node    = 4'h5;
            g_cost       = 8'd50;
            h_cost       = 8'd0;
            valid        = 1;
            @(posedge clk);
            valid        = 0;

            repeat(4) @(posedge clk);

            #1;


            check_outputs(8'd50, 4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Deep path exploration", test_num);
            reset_dut();
            current_node = 4'hA;
            goal_node    = 4'hF;
            g_cost       = 8'd120;
            h_cost       = 8'd40;
            valid        = 1;
            @(posedge clk);
            valid        = 0;

            repeat(4) @(posedge clk);

            #1;


            check_outputs(8'd160, 4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Maximum cost summation", test_num);
            reset_dut();
            current_node = 4'h2;
            goal_node    = 4'hE;
            g_cost       = 8'd128;
            h_cost       = 8'd127;
            valid        = 1;
            @(posedge clk);
            valid        = 0;

            repeat(4) @(posedge clk);

            #1;


            check_outputs(8'd255, 4'hE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Small cost calculation", test_num);
            reset_dut();
            current_node = 4'h0;
            goal_node    = 4'h1;
            g_cost       = 8'd1;
            h_cost       = 8'd1;
            valid        = 1;
            @(posedge clk);
            valid        = 0;

            repeat(4) @(posedge clk);

            #1;


            check_outputs(8'd2, 4'h1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("AStarFSM Testbench");
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
        input [7:0] expected_f_cost;
        input [3:0] expected_next_node;
        begin
            if (expected_f_cost === (expected_f_cost ^ f_cost ^ expected_f_cost) &&
                expected_next_node === (expected_next_node ^ next_node ^ expected_next_node)) begin
                $display("PASS");
                $display("  Outputs: f_cost=%h, next_node=%h",
                         f_cost, next_node);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: f_cost=%h, next_node=%h",
                         expected_f_cost, expected_next_node);
                $display("  Got:      f_cost=%h, next_node=%h",
                         f_cost, next_node);
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
        $dumpvars(0,clk, current_node, g_cost, goal_node, h_cost, reset, valid, f_cost, next_node);
    end

endmodule
