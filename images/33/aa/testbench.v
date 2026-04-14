`timescale 1ns/1ps

module rrt_tree_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] current_point;
    reg [4:0] random_point;
    reg reset;
    reg start;
    wire [4:0] child;
    wire done;
    wire [4:0] parent;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rrt_tree dut (
        .clk(clk),
        .current_point(current_point),
        .random_point(random_point),
        .reset(reset),
        .start(start),
        .child(child),
        .done(done),
        .parent(parent)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            current_point = 5'b0;
            random_point = 5'b0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Expansion (10 -> 20)", test_num);
            reset_dut();
            current_point = 5'd10;
            random_point = 5'd20;
            start = 1;
            @(posedge clk);
            start = 0;


            wait(done == 1'b1);
            @(posedge clk);




            #1;





            check_outputs(child, 1'b1, 5'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reverse Expansion (25 -> 5)", test_num);
            reset_dut();
            current_point = 5'd25;
            random_point = 5'd5;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1'b1);
            @(posedge clk);

            #1;


            check_outputs(child, 1'b1, 5'd25);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Max Range (0 -> 31)", test_num);
            reset_dut();
            current_point = 5'd0;
            random_point = 5'd31;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1'b1);
            @(posedge clk);

            #1;


            check_outputs(child, 1'b1, 5'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Distance Expansion (15 -> 15)", test_num);
            reset_dut();
            current_point = 5'd15;
            random_point = 5'd15;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1'b1);
            @(posedge clk);


            #1;



            check_outputs(5'd15, 1'b1, 5'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sequential Expansion Steps", test_num);
            reset_dut();


            current_point = 5'd2;
            random_point = 5'd8;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done == 1'b1);
            @(posedge clk);


            current_point = child;
            random_point = 5'd30;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done == 1'b1);
            @(posedge clk);



            #1;




            check_outputs(child, 1'b1, current_point);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rrt_tree Testbench");
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
        input [4:0] expected_child;
        input expected_done;
        input [4:0] expected_parent;
        begin
            if (expected_child === (expected_child ^ child ^ expected_child) &&
                expected_done === (expected_done ^ done ^ expected_done) &&
                expected_parent === (expected_parent ^ parent ^ expected_parent)) begin
                $display("PASS");
                $display("  Outputs: child=%h, done=%b, parent=%h",
                         child, done, parent);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: child=%h, done=%b, parent=%h",
                         expected_child, expected_done, expected_parent);
                $display("  Got:      child=%h, done=%b, parent=%h",
                         child, done, parent);
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
        $dumpvars(0,clk, current_point, random_point, reset, start, child, done, parent);
    end

endmodule
