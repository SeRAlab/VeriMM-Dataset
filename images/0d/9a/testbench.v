`timescale 1ns/1ps

module dfs_tree_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg new_node;
    reg reset;
    wire [2:0] current_node;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dfs_tree dut (
        .clk(clk),
        .new_node(new_node),
        .reset(reset),
        .current_node(current_node)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        new_node = 0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Checking root node after reset", test_num);
        reset_dut();
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Move from 0 to 1", test_num);
        reset_dut();
        new_node = 1;
        @(posedge clk);
        #1 new_node = 0;
        #1;

        check_outputs(3'd1);
    end
        endtask

    task testcase003;

    integer i;
    begin
        test_num = 3;
        $display("Testcase %03d: Move from 0 to 3 (0->1->3)", test_num);
        reset_dut();
        for (i = 0; i < 2; i = i + 1) begin
            new_node = 1;
            @(posedge clk);
            #1;
        end
        new_node = 0;
        #1;

        check_outputs(3'd3);
    end
        endtask

    task testcase004;

    integer i;
    begin
        test_num = 4;
        $display("Testcase %03d: Move from 0 to 7 (0->1->3->7)", test_num);
        reset_dut();
        for (i = 0; i < 3; i = i + 1) begin
            new_node = 1;
            @(posedge clk);
            #1;
        end
        new_node = 0;
        #1;

        check_outputs(3'd7);
    end
        endtask

    task testcase005;

    integer i;
    begin
        test_num = 5;
        $display("Testcase %03d: Move to 4 (Backtrack from 7 to 3, then 1, then Right to 4)", test_num);
        reset_dut();
        for (i = 0; i < 4; i = i + 1) begin
            new_node = 1;
            @(posedge clk);
            #1;
        end
        new_node = 0;
        #1;

        check_outputs(3'd4);
    end
        endtask

    task testcase006;

    integer i;
    begin
        test_num = 6;
        $display("Testcase %03d: Move to 2 (Right of root 0)", test_num);
        reset_dut();
        for (i = 0; i < 5; i = i + 1) begin
            new_node = 1;
            @(posedge clk);
            #1;
        end
        new_node = 0;
        #1;

        check_outputs(3'd2);
    end
        endtask

    task testcase007;

    integer i;
    begin
        test_num = 7;
        $display("Testcase %03d: Move to 6 (Last node in traversal)", test_num);
        reset_dut();
        for (i = 0; i < 7; i = i + 1) begin
            new_node = 1;
            @(posedge clk);
            #1;
        end
        new_node = 0;
        #1;

        check_outputs(3'd6);
    end
        endtask

    task testcase008;

    integer i;
    begin
        test_num = 8;
        $display("Testcase %03d: Verify node holds state when new_node=0", test_num);
        reset_dut();

        for (i = 0; i < 2; i = i + 1) begin
            new_node = 1;
            @(posedge clk);
            #1;
        end

        new_node = 0;
        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(3'd3);
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
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [2:0] expected_current_node;
        begin
            if (expected_current_node === (expected_current_node ^ current_node ^ expected_current_node)) begin
                $display("PASS");
                $display("  Outputs: current_node=%h",
                         current_node);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_node=%h",
                         expected_current_node);
                $display("  Got:      current_node=%h",
                         current_node);
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
        $dumpvars(0,clk, new_node, reset, current_node);
    end

endmodule
