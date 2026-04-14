`timescale 1ns/1ps

module dfs_stack_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] node_in;
    reg reset;
    reg start;
    wire [3:0] current_node;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dfs_stack dut (
        .clk(clk),
        .node_in(node_in),
        .reset(reset),
        .start(start),
        .current_node(current_node),
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
            start = 0;
            node_in = 4'b0000;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: DFS starting from node 0", test_num);
            reset_dut();

            node_in = 4'd0;
            start = 1;
            @(posedge clk);
            #1 start = 0;



            wait(done == 1);
            @(posedge clk);
            #1;





            #1;






            check_outputs(current_node, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: DFS starting from node 5", test_num);
            reset_dut();

            node_in = 4'd5;
            start = 1;
            @(posedge clk);
            #1 start = 0;


            wait(done == 1);
            @(posedge clk);
            #1;

            #1;


            check_outputs(current_node, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset mid-operation", test_num);
            reset_dut();

            node_in = 4'd2;
            start = 1;
            @(posedge clk);
            #1 start = 0;


            repeat(3) @(posedge clk);


            reset = 1;
            @(posedge clk);
            #1 reset = 0;


            #1;



            check_outputs(4'b0000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: DFS starting from node 15", test_num);
            reset_dut();

            node_in = 4'd15;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done == 1);
            @(posedge clk);
            #1;

            #1;


            check_outputs(current_node, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dfs_stack Testbench");
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
        input [3:0] expected_current_node;
        input expected_done;
        begin
            if (expected_current_node === (expected_current_node ^ current_node ^ expected_current_node) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: current_node=%h, done=%b",
                         current_node, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_node=%h, done=%b",
                         expected_current_node, expected_done);
                $display("  Got:      current_node=%h, done=%b",
                         current_node, done);
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
        $dumpvars(0,clk, node_in, reset, start, current_node, done);
    end

endmodule
