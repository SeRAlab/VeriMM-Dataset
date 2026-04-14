`timescale 1ns/1ps

module dfs_tree_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] node_value;
    reg reset;
    reg start;
    wire done;
    wire [3:0] output_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dfs_tree dut (
        .clk(clk),
        .node_value(node_value),
        .reset(reset),
        .start(start),
        .done(done),
        .output_value(output_value)
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
            node_value = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: System Reset and Idle Check", test_num);
            reset_dut();


            #1;



            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full DFS Traversal", test_num);
            reset_dut();


            start = 1;
            node_value = 4'h1;
            @(posedge clk);
            start = 0;



            while (!done) @(posedge clk);




            #1;





            check_outputs(1'b1, 4'h7);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Restart Search After Done", test_num);


            reset_dut();
            start = 1;
            @(posedge clk);
            start = 0;
            while (!done) @(posedge clk);


            reset_dut();
            start = 1;
            node_value = 4'h1;
            @(posedge clk);
            start = 0;


            while (!done) @(posedge clk);


            #1;



            check_outputs(1'b1, 4'h7);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pulse Start Signal", test_num);
            reset_dut();


            start = 1;
            node_value = 4'h1;
            @(posedge clk);
            start = 0;


            while (!done) @(posedge clk);


            #1;



            check_outputs(1'b1, 4'h7);
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
        input [3:0] expected_output_value;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_output_value === (expected_output_value ^ output_value ^ expected_output_value)) begin
                $display("PASS");
                $display("  Outputs: done=%b, output_value=%h",
                         done, output_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, output_value=%h",
                         expected_done, expected_output_value);
                $display("  Got:      done=%b, output_value=%h",
                         done, output_value);
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
        $dumpvars(0,clk, node_value, reset, start, done, output_value);
    end

endmodule
