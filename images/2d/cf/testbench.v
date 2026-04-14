`timescale 1ns/1ps

module bst_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg insert;
    reg reset;
    reg search;
    reg [7:0] value;
    wire found;
    wire [7:0] tree_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bst dut (
        .clk(clk),
        .insert(insert),
        .reset(reset),
        .search(search),
        .value(value),
        .found(found),
        .tree_value(tree_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            insert = 0;
            search = 0;
            value = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Insert and Search Root", test_num);
            reset_dut();


            value = 8'd50;
            insert = 1;
            @(posedge clk);
            insert = 0;
            repeat(10) @(posedge clk);


            value = 8'd50;
            search = 1;
            @(posedge clk);
            search = 0;
            repeat(10) @(posedge clk);

            #1;


            check_outputs(1'b1, 8'd50);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Insert multiple and Search Left Child", test_num);
            reset_dut();


            value = 8'd50; insert = 1; @(posedge clk); insert = 0;
            repeat(10) @(posedge clk);


            value = 8'd25; insert = 1; @(posedge clk); insert = 0;
            repeat(10) @(posedge clk);


            value = 8'd75; insert = 1; @(posedge clk); insert = 0;
            repeat(10) @(posedge clk);


            value = 8'd25; search = 1; @(posedge clk); search = 0;
            repeat(10) @(posedge clk);

            #1;


            check_outputs(1'b1, 8'd25);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Search for non-existent value", test_num);
            reset_dut();


            value = 8'd50; insert = 1; @(posedge clk); insert = 0;
            repeat(10) @(posedge clk);


            value = 8'd100; search = 1; @(posedge clk); search = 0;
            repeat(20) @(posedge clk);

            #1;


            check_outputs(1'b0, 8'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Complex tree insertion and deep search", test_num);
            reset_dut();


            value = 8'd50; insert = 1; @(posedge clk); insert = 0; repeat(10) @(posedge clk);
            value = 8'd25; insert = 1; @(posedge clk); insert = 0; repeat(10) @(posedge clk);
            value = 8'd75; insert = 1; @(posedge clk); insert = 0; repeat(10) @(posedge clk);
            value = 8'd12; insert = 1; @(posedge clk); insert = 0; repeat(10) @(posedge clk);
            value = 8'd37; insert = 1; @(posedge clk); insert = 0; repeat(10) @(posedge clk);


            value = 8'd37; search = 1; @(posedge clk); search = 0;
            repeat(20) @(posedge clk);

            #1;


            check_outputs(1'b1, 8'd37);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Search for Right Child", test_num);
            reset_dut();


            value = 8'd50; insert = 1; @(posedge clk); insert = 0; repeat(10) @(posedge clk);
            value = 8'd75; insert = 1; @(posedge clk); insert = 0; repeat(10) @(posedge clk);


            value = 8'd75; search = 1; @(posedge clk); search = 0;
            repeat(15) @(posedge clk);

            #1;


            check_outputs(1'b1, 8'd75);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bst Testbench");
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
        input expected_found;
        input [7:0] expected_tree_value;
        begin
            if (expected_found === (expected_found ^ found ^ expected_found) &&
                expected_tree_value === (expected_tree_value ^ tree_value ^ expected_tree_value)) begin
                $display("PASS");
                $display("  Outputs: found=%b, tree_value=%h",
                         found, tree_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: found=%b, tree_value=%h",
                         expected_found, expected_tree_value);
                $display("  Got:      found=%b, tree_value=%h",
                         found, tree_value);
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
        $dumpvars(0,clk, insert, reset, search, value, found, tree_value);
    end

endmodule
