`timescale 1ns/1ps

module bst_insert_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] value;
    wire [7:0] root;
    wire success;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bst_insert dut (
        .clk(clk),
        .value(value),
        .root(root),
        .success(success)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            value = 8'd0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Basic Root Insertion", test_num);
            reset_dut();
            value = 8'd50;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd50, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Multiple Insertions (L/R Child)", test_num);
            reset_dut();
            value = 8'd50; @(posedge clk); #2;
            value = 8'd25; @(posedge clk); #2;
            value = 8'd75; @(posedge clk); #2;

            #1;


            check_outputs(8'd50, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Duplicate Value Insertion", test_num);
            reset_dut();
            value = 8'd40; @(posedge clk); #2;
            value = 8'd40; @(posedge clk); #2;

            #1;


            check_outputs(8'd40, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Deeper Tree Traversal", test_num);
            reset_dut();
            value = 8'd100; @(posedge clk); #2;
            value = 8'd50;  @(posedge clk); #2;
            value = 8'd25;  @(posedge clk); #2;

            #1;


            check_outputs(8'd100, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Range Boundaries", test_num);
            reset_dut();
            value = 8'd128; @(posedge clk); #2;
            value = 8'd255; @(posedge clk); #2;
            value = 8'd1;   @(posedge clk); #2;
            #1;

            check_outputs(8'd128, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bst_insert Testbench");
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
        input [7:0] expected_root;
        input expected_success;
        begin
            if (expected_root === (expected_root ^ root ^ expected_root) &&
                expected_success === (expected_success ^ success ^ expected_success)) begin
                $display("PASS");
                $display("  Outputs: root=%h, success=%b",
                         root, success);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: root=%h, success=%b",
                         expected_root, expected_success);
                $display("  Got:      root=%h, success=%b",
                         root, success);
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
        $dumpvars(0,clk, value, root, success);
    end

endmodule
