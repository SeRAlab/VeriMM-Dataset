`timescale 1ns/1ps

module dfs_search_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg node_valid;
    reg [7:0] node_value;
    reg reset;
    reg [7:0] target;
    wire found;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dfs_search dut (
        .clk(clk),
        .node_valid(node_valid),
        .node_value(node_value),
        .reset(reset),
        .target(target),
        .found(found)
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
        node_value = 8'h00;
        target = 8'h00;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Target found at root", test_num);
        reset_dut();

        target = 8'd15;
        @(posedge clk);
        node_valid = 1;
        node_value = 8'd15;
        @(posedge clk);
        node_valid = 0;

        repeat(2) @(posedge clk);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Target in left subtree", test_num);
        reset_dut();

        target = 8'd42;
        @(posedge clk);

        node_valid = 1; node_value = 8'd10; @(posedge clk);
        node_valid = 1; node_value = 8'd42; @(posedge clk);
        node_valid = 0;

        repeat(2) @(posedge clk);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Target in right subtree", test_num);
        reset_dut();

        target = 8'd99;
        @(posedge clk);

        node_valid = 1; node_value = 8'd50; @(posedge clk);
        node_valid = 1; node_value = 8'd20; @(posedge clk);
        node_valid = 1; node_value = 8'd10; @(posedge clk);
        node_valid = 1; node_value = 8'd99; @(posedge clk);
        node_valid = 0;

        repeat(2) @(posedge clk);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Target not found", test_num);
        reset_dut();

        target = 8'd255;
        @(posedge clk);
        node_valid = 1; node_value = 8'd01; @(posedge clk);
        node_valid = 1; node_value = 8'd02; @(posedge clk);
        node_valid = 1; node_value = 8'd03; @(posedge clk);
        node_valid = 0;

        repeat(2) @(posedge clk);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Search for zero value", test_num);
        reset_dut();

        target = 8'd0;
        @(posedge clk);
        node_valid = 1; node_value = 8'd100; @(posedge clk);
        node_valid = 1; node_value = 8'd0;   @(posedge clk);
        node_valid = 0;

        repeat(2) @(posedge clk);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset clears found signal", test_num);
        reset_dut();

        target = 8'd77;
        @(posedge clk);
        node_valid = 1; node_value = 8'd77; @(posedge clk);
        node_valid = 0;
        repeat(2) @(posedge clk);


        reset = 1;
        @(posedge clk);
        reset = 0;
        @(posedge clk);

        #1;


        check_outputs(1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dfs_search Testbench");
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
        input expected_found;
        begin
            if (expected_found === (expected_found ^ found ^ expected_found)) begin
                $display("PASS");
                $display("  Outputs: found=%b",
                         found);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: found=%b",
                         expected_found);
                $display("  Got:      found=%b",
                         found);
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
        $dumpvars(0,clk, node_valid, node_value, reset, target, found);
    end

endmodule
