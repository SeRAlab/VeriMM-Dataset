`timescale 1ns/1ps

module a_star_fsm_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] node_cost;
    reg rst;
    reg valid;
    wire [3:0] min_node;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    a_star_fsm dut (
        .clk(clk),
        .node_cost(node_cost),
        .rst(rst),
        .valid(valid),
        .min_node(min_node)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            node_cost = 0;
            valid = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Minimum in middle (Costs: 100, 50, 75)", test_num);
            reset_dut();


            node_cost = 8'd100;
            valid = 1;
            @(posedge clk);
            valid = 0;
            @(posedge clk);


            node_cost = 8'd50;
            valid = 1;
            @(posedge clk);
            valid = 0;
            @(posedge clk);


            node_cost = 8'd75;
            valid = 1;
            @(posedge clk);
            valid = 0;
            @(posedge clk);


            #1;



            check_outputs(4'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Minimum is the first node (Costs: 10, 20, 30)", test_num);
            reset_dut();


            node_cost = 8'd10;
            valid = 1;
            @(posedge clk);
            valid = 0;
            @(posedge clk);


            node_cost = 8'd20;
            valid = 1;
            @(posedge clk);
            valid = 0;
            @(posedge clk);


            node_cost = 8'd30;
            valid = 1;
            @(posedge clk);
            valid = 0;
            @(posedge clk);

            #1;


            check_outputs(4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Minimum is the last node (Costs: 250, 200, 150, 100, 50)", test_num);
            reset_dut();


            node_cost = 8'd250; valid = 1; @(posedge clk);
            node_cost = 8'd200; valid = 1; @(posedge clk);
            node_cost = 8'd150; valid = 1; @(posedge clk);
            node_cost = 8'd100; valid = 1; @(posedge clk);

            node_cost = 8'd50;  valid = 1; @(posedge clk);
            valid = 0;
            @(posedge clk);

            #1;


            check_outputs(4'd4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Tie-breaking (Costs: 40, 60, 40)", test_num);
            reset_dut();


            node_cost = 8'd40; valid = 1; @(posedge clk);

            node_cost = 8'd60; valid = 1; @(posedge clk);

            node_cost = 8'd40; valid = 1; @(posedge clk);
            valid = 0;
            @(posedge clk);


            #1;



            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Handling Max Values (Costs: 255, 254)", test_num);
            reset_dut();

            node_cost = 8'hFF; valid = 1; @(posedge clk);
            node_cost = 8'hFE; valid = 1; @(posedge clk);
            valid = 0;
            @(posedge clk);

            #1;


            check_outputs(4'd1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("a_star_fsm Testbench");
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
        input [3:0] expected_min_node;
        begin
            if (expected_min_node === (expected_min_node ^ min_node ^ expected_min_node)) begin
                $display("PASS");
                $display("  Outputs: min_node=%h",
                         min_node);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: min_node=%h",
                         expected_min_node);
                $display("  Got:      min_node=%h",
                         min_node);
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
        $dumpvars(0,clk, node_cost, rst, valid, min_node);
    end

endmodule
