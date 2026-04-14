`timescale 1ns/1ps

module dfs_traversal_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] root;
    wire done;
    wire [7:0] node_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dfs_traversal dut (
        .clk(clk),
        .reset(reset),
        .root(root),
        .done(done),
        .node_value(node_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            root = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Node Tree", test_num);
            reset_dut();
            root = 8'd1;


            while (!done) @(posedge clk);



            #1;




            check_outputs(1'b1, 8'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Balanced Tree", test_num);
            reset_dut();
            root = 8'd1;

            while (!done) @(posedge clk);


            #1;



            check_outputs(1'b1, 8'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Left-Skewed Tree", test_num);
            reset_dut();
            root = 8'd10;

            while (!done) @(posedge clk);


            #1;



            check_outputs(1'b1, 8'd30);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Right-Skewed Tree", test_num);
            reset_dut();
            root = 8'd5;

            while (!done) @(posedge clk);


            #1;



            check_outputs(1'b1, 8'd7);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Complex Tree", test_num);
            reset_dut();
            root = 8'd50;

            while (!done) @(posedge clk);


            #1;



            check_outputs(1'b1, 8'd80);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Empty Tree", test_num);
            reset_dut();
            root = 8'd0;


            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b1, 8'd0);
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
        input expected_done;
        input [7:0] expected_node_value;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_node_value === (expected_node_value ^ node_value ^ expected_node_value)) begin
                $display("PASS");
                $display("  Outputs: done=%b, node_value=%h",
                         done, node_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, node_value=%h",
                         expected_done, expected_node_value);
                $display("  Got:      done=%b, node_value=%h",
                         done, node_value);
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
        $dumpvars(0,clk, reset, root, done, node_value);
    end

endmodule
