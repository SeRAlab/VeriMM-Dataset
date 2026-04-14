`timescale 1ns/1ps

module dfs_tree_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] current_node;
    reg [7:0] next_node;
    reg pop;
    reg push;
    reg reset;
    wire [7:0] visited_nodes;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dfs_tree dut (
        .clk(clk),
        .current_node(current_node),
        .next_node(next_node),
        .pop(pop),
        .push(push),
        .reset(reset),
        .visited_nodes(visited_nodes)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            current_node = 0;
            next_node = 0;
            push = 0;
            pop = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            current_node = 8'd0;
            push = 1;
            @(posedge clk);
            push = 0;
            #1;

            check_outputs(8'b0000_0001);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            current_node = 8'd0; push = 1; @(posedge clk);

            current_node = 8'd0; next_node = 8'd1; push = 1; @(posedge clk);

            current_node = 8'd1; next_node = 8'd3; push = 1; @(posedge clk);
            push = 0;
            #1;

            check_outputs(8'b0000_1011);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            current_node = 8'd0; push = 1; @(posedge clk);

            current_node = 8'd0; next_node = 8'd1; push = 1; @(posedge clk);
            push = 0; @(posedge clk);

            pop = 1; @(posedge clk);
            pop = 0;

            current_node = 8'd0; next_node = 8'd2; push = 1; @(posedge clk);
            push = 0;
            #1;

            check_outputs(8'b0000_0111);
        end
        endtask

    task testcase004;

        integer i;
        begin
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                current_node = (i == 0) ? 8'd0 : i-1;
                next_node = i;
                push = 1;
                @(posedge clk);
            end
            push = 0;
            #1;

            check_outputs(8'b1111_1111);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            current_node = 8'd0; push = 1; @(posedge clk);
            current_node = 8'd0; next_node = 8'd5; push = 1; @(posedge clk);
            push = 0;

            reset = 1; @(posedge clk);
            reset = 0; @(posedge clk);
            #1;

            check_outputs(8'b0000_0000);
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
        input [7:0] expected_visited_nodes;
        begin
            if (expected_visited_nodes === (expected_visited_nodes ^ visited_nodes ^ expected_visited_nodes)) begin
                $display("PASS");
                $display("  Outputs: visited_nodes=%h",
                         visited_nodes);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: visited_nodes=%h",
                         expected_visited_nodes);
                $display("  Got:      visited_nodes=%h",
                         visited_nodes);
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
        $dumpvars(0,clk, current_node, next_node, pop, push, reset, visited_nodes);
    end

endmodule
