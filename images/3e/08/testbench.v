`timescale 1ns/1ps

module bfs_tree_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] node_value;
    reg reset;
    reg valid;
    wire [7:0] bfs_output;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bfs_tree dut (
        .clk(clk),
        .node_value(node_value),
        .reset(reset),
        .valid(valid),
        .bfs_output(bfs_output),
        .done(done)
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
            node_value = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Simple 3-node tree...", test_num);
            reset_dut();


            node_value = 8'd1; valid = 1; @(posedge clk);

            node_value = 8'd2; valid = 1; @(posedge clk);
            node_value = 8'd3; valid = 1; @(posedge clk);

            valid = 0;


            wait(done == 1'b1);
            @(posedge clk);


            #1;



            check_outputs(8'd3, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Single-node tree...", test_num);
            reset_dut();

            node_value = 8'hA5; valid = 1; @(posedge clk);
            valid = 0;

            wait(done == 1'b1);
            @(posedge clk);

            #1;


            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: 7-node complete tree...", test_num);
            reset_dut();


            node_value = 8'd10; valid = 1; @(posedge clk);

            node_value = 8'd20; valid = 1; @(posedge clk);
            node_value = 8'd30; valid = 1; @(posedge clk);

            node_value = 8'd40; valid = 1; @(posedge clk);
            node_value = 8'd50; valid = 1; @(posedge clk);
            node_value = 8'd60; valid = 1; @(posedge clk);
            node_value = 8'd70; valid = 1; @(posedge clk);

            valid = 0;

            wait(done == 1'b1);
            @(posedge clk);

            #1;


            check_outputs(8'd70, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Unbalanced 2-node tree...", test_num);
            reset_dut();

            node_value = 8'd100; valid = 1; @(posedge clk);
            node_value = 8'd101; valid = 1; @(posedge clk);
            valid = 0;

            wait(done == 1'b1);
            @(posedge clk);

            #1;


            check_outputs(8'd101, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bfs_tree Testbench");
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
        input [7:0] expected_bfs_output;
        input expected_done;
        begin
            if (expected_bfs_output === (expected_bfs_output ^ bfs_output ^ expected_bfs_output) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: bfs_output=%h, done=%b",
                         bfs_output, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bfs_output=%h, done=%b",
                         expected_bfs_output, expected_done);
                $display("  Got:      bfs_output=%h, done=%b",
                         bfs_output, done);
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
        $dumpvars(0,clk, node_value, reset, valid, bfs_output, done);
    end

endmodule
