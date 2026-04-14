`timescale 1ns/1ps

module linked_list_traversal_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] next_node;
    reg [7:0] node_data;
    reg reset;
    reg start;
    wire done;
    wire [7:0] out_data;

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
        .out_data(out_data)
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
            repeat (2) @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Traversing a 3-node linked list", test_num);
            reset_dut();


            node_data = 8'hA1;
            next_node = 8'h01;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;


            node_data = 8'hB2;
            next_node = 8'h02;
            @(posedge clk);
            #1;


            node_data = 8'hC3;
            next_node = 8'h00;
            @(posedge clk);
            #1;


            while (!done) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 8'hC3);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Traversing a single-node list", test_num);
            reset_dut();


            node_data = 8'hFF;
            next_node = 8'h00;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;

            while (!done) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Traversing a 5-node list", test_num);
            reset_dut();


            node_data = 8'h01; next_node = 8'h10; start = 1;
            @(posedge clk); #1; start = 0;


            node_data = 8'h02; next_node = 8'h20;
            @(posedge clk); #1;


            node_data = 8'h03; next_node = 8'h30;
            @(posedge clk); #1;


            node_data = 8'h04; next_node = 8'h40;
            @(posedge clk); #1;


            node_data = 8'h05; next_node = 8'h00;
            @(posedge clk); #1;

            while (!done) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 8'h05);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Consecutive traversal check", test_num);
            reset_dut();


            node_data = 8'h11; next_node = 8'h01; start = 1;
            @(posedge clk); #1; start = 0;
            node_data = 8'h22; next_node = 8'h00;
            @(posedge clk); #1;
            while (!done) @(posedge clk);


            reset_dut();
            node_data = 8'h99; next_node = 8'h00; start = 1;
            @(posedge clk); #1; start = 0;
            while (!done) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 8'h99);
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
        input [7:0] expected_out_data;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_out_data === (expected_out_data ^ out_data ^ expected_out_data)) begin
                $display("PASS");
                $display("  Outputs: done=%b, out_data=%h",
                         done, out_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, out_data=%h",
                         expected_done, expected_out_data);
                $display("  Got:      done=%b, out_data=%h",
                         done, out_data);
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
        $dumpvars(0,clk, next_node, node_data, reset, start, done, out_data);
    end

endmodule
