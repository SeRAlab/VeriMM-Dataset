`timescale 1ns/1ps

module linked_list_traversal_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] next_node;
    reg [3:0] node_data;
    reg reset;
    reg start;
    wire done;
    wire [3:0] output_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linked_list_traversal dut (
        .clk(clk),
        .next_node(next_node),
        .node_data(node_data),
        .reset(reset),
        .start(start),
        .done(done),
        .output_data(output_data)
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
            next_node = 0;
            node_data = 0;
            repeat(2) @(posedge clk);
            #1;
            reset = 0;
            repeat(1) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: 3-node traversal (Data: 5, A, 3)");
            reset_dut();


            start = 1;
            node_data = 4'h5;
            next_node = 4'h1;
            @(posedge clk);
            #1;
            start = 0;


            node_data = 4'hA;
            next_node = 4'h2;
            @(posedge clk);
            #1;


            node_data = 4'h3;
            next_node = 4'h0;


            wait(done == 1);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'h3);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: Single-node traversal (Data: 7)");
            reset_dut();

            start = 1;
            node_data = 4'h7;
            next_node = 4'h0;
            @(posedge clk);
            #1;
            start = 0;

            wait(done == 1);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'h7);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: 4-node traversal (Data: F, 0, E, 1)");
            reset_dut();

            start = 1;
            node_data = 4'hF;
            next_node = 4'h1;
            @(posedge clk);
            #1;
            start = 0;

            node_data = 4'h0;
            next_node = 4'h2;
            @(posedge clk);
            #1;

            node_data = 4'hE;
            next_node = 4'h3;
            @(posedge clk);
            #1;

            node_data = 4'h1;
            next_node = 4'h0;

            wait(done == 1);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'h1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Reset during traversal then restart");
            reset_dut();

            start = 1;
            node_data = 4'h1;
            next_node = 4'h1;
            @(posedge clk);
            #1;
            start = 0;


            reset = 1;
            repeat(2) @(posedge clk);
            reset = 0;
            @(posedge clk);


            start = 1;
            node_data = 4'hC;
            next_node = 4'h0;
            @(posedge clk);
            #1;
            start = 0;

            wait(done == 1);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'hC);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("linked_list_traversal Testbench");
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
        input [3:0] expected_output_data;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_output_data === (expected_output_data ^ output_data ^ expected_output_data)) begin
                $display("PASS");
                $display("  Outputs: done=%b, output_data=%h",
                         done, output_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, output_data=%h",
                         expected_done, expected_output_data);
                $display("  Got:      done=%b, output_data=%h",
                         done, output_data);
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
        $dumpvars(0,clk, next_node, node_data, reset, start, done, output_data);
    end

endmodule
