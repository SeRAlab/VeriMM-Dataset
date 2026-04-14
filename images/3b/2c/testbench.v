`timescale 1ns/1ps

module dfs_traversal_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] node_val;
    reg node_valid;
    reg rst;
    reg start;
    wire done;
    wire [7:0] output_val;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dfs_traversal dut (
        .clk(clk),
        .node_val(node_val),
        .node_valid(node_valid),
        .rst(rst),
        .start(start),
        .done(done),
        .output_val(output_val)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            node_val = 0;
            node_valid = 0;
            repeat (2) @(posedge clk);
            #1 rst = 0;
            repeat (1) @(posedge clk);
        end
        endtask
    task load_node;

        input [7:0] val;
        begin
            @(posedge clk);
            node_val = val;
            node_valid = 1;
            @(posedge clk);
            node_valid = 0;
        end
        endtask

    task testcase001;

        begin
            $display("\nRunning testcase001: Single Node Tree");
            reset_dut();


            load_node(8'h0A);


            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            wait(done);
            @(posedge clk);



            #1;




            check_outputs(1'b1, 8'h0A);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Simple 3-Node Tree");
            reset_dut();


            load_node(8'h0A);
            load_node(8'h14);
            load_node(8'h1E);

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 8'h1E);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Left-heavy Chain Tree");
            reset_dut();

            load_node(8'h32);
            load_node(8'h28);
            load_node(8'h1E);

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 8'h1E);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Complex Tree Traversal");
            reset_dut();

            load_node(8'h64);
            load_node(8'h32);
            load_node(8'h4B);
            load_node(8'h96);

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 8'h96);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Reset during operation");
            reset_dut();

            load_node(8'hAA);
            load_node(8'hBB);

            @(posedge clk);
            start = 1;
            repeat(2) @(posedge clk);


            rst = 1;
            @(posedge clk);
            rst = 0;
            start = 0;


            load_node(8'hFF);
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 8'hFF);
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
        input [7:0] expected_output_val;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_output_val === (expected_output_val ^ output_val ^ expected_output_val)) begin
                $display("PASS");
                $display("  Outputs: done=%b, output_val=%h",
                         done, output_val);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, output_val=%h",
                         expected_done, expected_output_val);
                $display("  Got:      done=%b, output_val=%h",
                         done, output_val);
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
        $dumpvars(0,clk, node_val, node_valid, rst, start, done, output_val);
    end

endmodule
