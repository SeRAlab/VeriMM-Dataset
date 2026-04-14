`timescale 1ns/1ps

module BST_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ctrl;
    reg [31:0] data;
    wire found;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    BST dut (
        .clk(clk),
        .ctrl(ctrl),
        .data(data),
        .found(found)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        ctrl = 0;
        data = 0;
        repeat (2) @(posedge clk);
        rst = 0;
        repeat (1) @(posedge clk);
    end
        endtask
    task insert;

        input [31:0] val;
        begin
            @(posedge clk);
            ctrl = 1'b0;
            data = val;
            #1;
        end
        endtask

    task search;

        input [31:0] val;
        begin
            @(posedge clk);
            ctrl = 1'b1;
            data = val;
            #1;
            @(posedge clk);
        end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Insert and Search Root", test_num);
        reset_dut();
        insert(32'd50);
        search(32'd50);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Search empty tree", test_num);
        reset_dut();
        search(32'd10);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Search left child (smaller)", test_num);
        reset_dut();
        insert(32'd100);
        insert(32'd50);
        insert(32'd150);
        search(32'd50);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Search right child (larger)", test_num);
        reset_dut();
        insert(32'd100);
        insert(32'd50);
        insert(32'd150);
        search(32'd150);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Deep tree search (unbalanced sequence)", test_num);
        reset_dut();
        insert(32'd10);
        insert(32'd20);
        insert(32'd30);
        insert(32'd40);
        search(32'd40);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Search for missing value in populated tree", test_num);
        reset_dut();
        insert(32'd50);
        insert(32'd25);
        insert(32'd75);
        search(32'd60);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Complex insertion sequence", test_num);
        reset_dut();
        insert(32'd80);
        insert(32'd40);
        insert(32'd120);
        insert(32'd20);
        insert(32'd60);
        insert(32'd100);
        insert(32'd140);
        search(32'd100);
        #1;

        check_outputs(1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("BST Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        $dumpvars(0,clk, ctrl, data, found);
    end

endmodule
