`timescale 1ns/1ps

module linked_list_traversal_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] node_data;
    reg node_valid;
    reg reset;
    wire [31:0] node_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linked_list_traversal dut (
        .clk(clk),
        .node_data(node_data),
        .node_valid(node_valid),
        .reset(reset),
        .node_count(node_count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        node_valid = 0;
        node_data = 0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Empty Linked List", test_num);
        reset_dut();


        node_valid = 0;
        repeat(2) @(posedge clk);

        #1;


        check_outputs(32'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single Node List", test_num);
        reset_dut();

        node_valid = 1;
        node_data = 32'hAAAA_BBBB;
        @(posedge clk);
        #1;
        node_valid = 0;
        @(posedge clk);

        #1;


        check_outputs(32'd1);
    end
        endtask

    task testcase003;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Small Linked List (5 nodes)", test_num);
        reset_dut();

        for (i = 0; i < 5; i = i + 1) begin
            node_valid = 1;
            node_data = i + 32'h100;
            @(posedge clk);
            #1;
        end
        node_valid = 0;
        @(posedge clk);

        #1;


        check_outputs(32'd5);
    end
        endtask

    task testcase004;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Moderate Linked List (15 nodes)", test_num);
        reset_dut();

        for (i = 0; i < 15; i = i + 1) begin
            node_valid = 1;
            node_data = $random;
            @(posedge clk);
            #1;
        end
        node_valid = 0;
        @(posedge clk);

        #1;


        check_outputs(32'd15);
    end
        endtask

    task testcase005;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Interrupted Traversal Reset", test_num);
        reset_dut();


        for (i = 0; i < 10; i = i + 1) begin
            node_valid = 1;
            node_data = i;
            @(posedge clk);
            #1;
        end


        reset_dut();


        for (i = 0; i < 3; i = i + 1) begin
            node_valid = 1;
            node_data = i;
            @(posedge clk);
            #1;
        end
        node_valid = 0;
        @(posedge clk);

        #1;


        check_outputs(32'd3);
    end
        endtask

    task testcase006;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Large Linked List (100 nodes)", test_num);
        reset_dut();

        for (i = 0; i < 100; i = i + 1) begin
            node_valid = 1;
            node_data = $random;
            @(posedge clk);
            #1;
        end
        node_valid = 0;
        @(posedge clk);

        #1;


        check_outputs(32'd100);
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
        input [31:0] expected_node_count;
        begin
            if (expected_node_count === (expected_node_count ^ node_count ^ expected_node_count)) begin
                $display("PASS");
                $display("  Outputs: node_count=%h",
                         node_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: node_count=%h",
                         expected_node_count);
                $display("  Got:      node_count=%h",
                         node_count);
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
        $dumpvars(0,clk, node_data, node_valid, reset, node_count);
    end

endmodule
