`timescale 1ns/1ps

module linked_list_traversal_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] next_node;
    reg [7:0] node_data;
    reg rst;
    wire [7:0] current_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linked_list_traversal dut (
        .clk(clk),
        .next_node(next_node),
        .node_data(node_data),
        .rst(rst),
        .current_data(current_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            next_node = 8'h00;
            node_data = 8'h00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Node Traversal", test_num);
            reset_dut();


            node_data = 8'hA5;
            next_node = 8'h01;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Two-node Traversal", test_num);
            reset_dut();


            node_data = 8'h11;
            next_node = 8'h01;
            @(posedge clk);


            #1;
            node_data = 8'h22;
            next_node = 8'h02;
            @(posedge clk);

            #1;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Four-node Traversal", test_num);
            reset_dut();


            node_data = 8'hD1; next_node = 8'h01; @(posedge clk);

            #1; node_data = 8'hD2; next_node = 8'h02; @(posedge clk);

            #1; node_data = 8'hD3; next_node = 8'h03; @(posedge clk);

            #1; node_data = 8'hD4; next_node = 8'h00; @(posedge clk);

            #1;
            #1;

            check_outputs(8'hD4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Persistence Check", test_num);
            reset_dut();


            node_data = 8'h77;
            next_node = 8'h05;
            @(posedge clk);


            repeat(3) @(posedge clk);

            #1;
            #1;

            check_outputs(8'h77);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Values", test_num);
            reset_dut();

            node_data = 8'hAA; @(posedge clk);
            #1; node_data = 8'h55; @(posedge clk);
            #1; node_data = 8'hAA; @(posedge clk);
            #1; node_data = 8'h55; @(posedge clk);

            #1;
            #1;

            check_outputs(8'h55);
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
        input [7:0] expected_current_data;
        begin
            if (expected_current_data === (expected_current_data ^ current_data ^ expected_current_data)) begin
                $display("PASS");
                $display("  Outputs: current_data=%h",
                         current_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_data=%h",
                         expected_current_data);
                $display("  Got:      current_data=%h",
                         current_data);
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
        $dumpvars(0,clk, next_node, node_data, rst, current_data);
    end

endmodule
