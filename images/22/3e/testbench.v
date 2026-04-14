`timescale 1ns/1ps

module linked_list_traversal_tb;

    // Testbench signals (sequential circuit)
    reg advance;
    reg clk;
    reg [3:0] node_value;
    reg reset;
    wire [3:0] current_value;
    wire end_of_list;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linked_list_traversal dut (
        .advance(advance),
        .clk(clk),
        .node_value(node_value),
        .reset(reset),
        .current_value(current_value),
        .end_of_list(end_of_list)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            advance = 0;
            node_value = 4'b0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single node list (Value 1)", test_num);
            reset_dut();


            node_value = 4'b0001;
            advance = 1;
            @(posedge clk);
            #1;


            node_value = 4'b1111;
            advance = 1;
            @(posedge clk);
            #1;

            advance = 0;

            #1;


            check_outputs(4'b1111, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single node list (Value 0)", test_num);
            reset_dut();


            node_value = 4'b0000;
            advance = 1;
            @(posedge clk);
            #1;


            node_value = 4'b1111;
            advance = 1;
            @(posedge clk);
            #1;

            advance = 0;
            #1;

            check_outputs(4'b1111, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multi-node list (1 -> 0 -> 1)", test_num);
            reset_dut();


            node_value = 4'b0001; advance = 1; @(posedge clk); #1;

            node_value = 4'b0000; advance = 1; @(posedge clk); #1;

            node_value = 4'b0001; advance = 1; @(posedge clk); #1;


            node_value = 4'b1111;
            advance = 1;
            @(posedge clk);
            #1;

            advance = 0;
            #1;

            check_outputs(4'b1111, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Immediate end of list", test_num);
            reset_dut();


            node_value = 4'b1111;
            advance = 1;
            @(posedge clk);
            #1;

            advance = 0;
            #1;

            check_outputs(4'b1111, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Long list traversal", test_num);
            reset_dut();


            node_value = 4'd1; advance = 1; @(posedge clk); #1;
            node_value = 4'd1; advance = 1; @(posedge clk); #1;
            node_value = 4'd0; advance = 1; @(posedge clk); #1;
            node_value = 4'd0; advance = 1; @(posedge clk); #1;
            node_value = 4'd1; advance = 1; @(posedge clk); #1;


            node_value = 4'b1111;
            advance = 1;
            @(posedge clk);
            #1;

            advance = 0;
            #1;

            check_outputs(4'b1111, 1'b1);
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
        input [3:0] expected_current_value;
        input expected_end_of_list;
        begin
            if (expected_current_value === (expected_current_value ^ current_value ^ expected_current_value) &&
                expected_end_of_list === (expected_end_of_list ^ end_of_list ^ expected_end_of_list)) begin
                $display("PASS");
                $display("  Outputs: current_value=%h, end_of_list=%b",
                         current_value, end_of_list);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_value=%h, end_of_list=%b",
                         expected_current_value, expected_end_of_list);
                $display("  Got:      current_value=%h, end_of_list=%b",
                         current_value, end_of_list);
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
        $dumpvars(0,advance, clk, node_value, reset, current_value, end_of_list);
    end

endmodule
