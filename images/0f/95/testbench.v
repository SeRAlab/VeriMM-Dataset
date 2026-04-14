`timescale 1ns/1ps

module linked_list_traversal_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] next_node;
    reg [7:0] node_value;
    wire [7:0] current_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linked_list_traversal dut (
        .clk(clk),
        .next_node(next_node),
        .node_value(node_value),
        .current_value(current_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        next_node = 8'h00;
        node_value = 8'h00;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Single node list (Value: 0xA5)", test_num);
        reset_dut();


        node_value = 8'hA5;
        next_node  = 8'h00;

        @(posedge clk);
        #1;

        #1;


        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: 3-node list traversal (0x11 -> 0x22 -> 0x33)", test_num);
        reset_dut();


        node_value = 8'h11;
        next_node  = 8'h01;
        @(posedge clk);
        #1;


        node_value = 8'h22;
        next_node  = 8'h02;
        @(posedge clk);
        #1;


        node_value = 8'h33;
        next_node  = 8'h00;
        @(posedge clk);
        #1;

        #1;


        check_outputs(8'h33);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Empty/Null head list", test_num);
        reset_dut();

        node_value = 8'h00;
        next_node  = 8'h00;

        @(posedge clk);
        #1;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Verify traversal stops and holds last value after null", test_num);
        reset_dut();


        node_value = 8'hAA;
        next_node  = 8'h01;
        @(posedge clk);
        #1;


        node_value = 8'hBB;
        next_node  = 8'h00;
        @(posedge clk);
        #1;


        node_value = 8'hFF;
        next_node  = 8'h05;
        @(posedge clk);
        #1;


        #1;



        check_outputs(8'hBB);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Long list traversal (5 nodes)", test_num);
        reset_dut();


        node_value = 8'd10; next_node = 8'h01; @(posedge clk); #1;
        node_value = 8'd20; next_node = 8'h02; @(posedge clk); #1;
        node_value = 8'd30; next_node = 8'h03; @(posedge clk); #1;
        node_value = 8'd40; next_node = 8'h04; @(posedge clk); #1;
        node_value = 8'd50; next_node = 8'h00; @(posedge clk); #1;

        #1;


        check_outputs(8'd50);
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
        input [7:0] expected_current_value;
        begin
            if (expected_current_value === (expected_current_value ^ current_value ^ expected_current_value)) begin
                $display("PASS");
                $display("  Outputs: current_value=%h",
                         current_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_value=%h",
                         expected_current_value);
                $display("  Got:      current_value=%h",
                         current_value);
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
        $dumpvars(0,clk, next_node, node_value, current_value);
    end

endmodule
