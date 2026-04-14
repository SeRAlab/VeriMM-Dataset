`timescale 1ns/1ps

module rrt_node_selector_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] node_id;
    reg rst;
    wire [2:0] selected_node;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rrt_node_selector dut (
        .clk(clk),
        .node_id(node_id),
        .rst(rst),
        .selected_node(selected_node)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            node_id = 3'b000;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing node_id 0", test_num);
            reset_dut();
            node_id = 3'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing node_id 3", test_num);
            reset_dut();
            node_id = 3'd3;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing node_id 6", test_num);
            reset_dut();
            node_id = 3'd6;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing wrap around (node_id 7)", test_num);
            reset_dut();
            node_id = 3'd7;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing node_id 5", test_num);
            reset_dut();
            node_id = 3'd5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'd6);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing node_id 1", test_num);
            reset_dut();
            node_id = 3'd1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'd2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rrt_node_selector Testbench");
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
        input [2:0] expected_selected_node;
        begin
            if (expected_selected_node === (expected_selected_node ^ selected_node ^ expected_selected_node)) begin
                $display("PASS");
                $display("  Outputs: selected_node=%h",
                         selected_node);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: selected_node=%h",
                         expected_selected_node);
                $display("  Got:      selected_node=%h",
                         selected_node);
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
        $dumpvars(0,clk, node_id, rst, selected_node);
    end

endmodule
