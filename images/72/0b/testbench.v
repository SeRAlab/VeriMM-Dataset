`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg bump_left;
    reg bump_right;
    reg clk;
    reg dig;
    reg ground;
    wire aaah;
    wire digging;
    wire walk_left;
    wire walk_right;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .areset(areset),
        .bump_left(bump_left),
        .bump_right(bump_right),
        .clk(clk),
        .dig(dig),
        .ground(ground),
        .aaah(aaah),
        .digging(digging),
        .walk_left(walk_left),
        .walk_right(walk_right)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

        begin
            areset = 1;
            bump_left = 0;
            bump_right = 0;
            ground = 1;
            dig = 0;
            #15;
            areset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge clk);
            bump_left = 1;
            @(posedge clk);
            bump_left = 0;
            #2;
            #1;

            check_outputs(0, 0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            @(posedge clk);
            bump_left = 1;
            @(posedge clk);
            bump_left = 0;

            @(posedge clk);
            bump_right = 1;
            @(posedge clk);
            bump_right = 0;
            #2;
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(posedge clk);
            dig = 1;
            @(posedge clk);
            dig = 0;
            #2;
            #1;

            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            bump_left = 1;
            @(posedge clk);
            bump_left = 0;
            @(posedge clk);
            dig = 1;
            @(posedge clk);
            dig = 0;
            #2;
            #1;

            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            @(posedge clk);
            ground = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            ground = 0;
            @(posedge clk);
            @(posedge clk);
            ground = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            dig = 1;
            @(posedge clk);
            dig = 0;
            @(posedge clk);
            ground = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            dig = 1;
            @(posedge clk);
            dig = 0;
            bump_left = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();
            bump_left = 1;
            @(posedge clk);
            bump_left = 0;
            dig = 1;
            @(posedge clk);
            dig = 0;
            ground = 0;
            @(posedge clk);
            ground = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0, 0, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input expected_aaah;
        input expected_digging;
        input expected_walk_left;
        input expected_walk_right;
        begin
            if (expected_aaah === (expected_aaah ^ aaah ^ expected_aaah) &&
                expected_digging === (expected_digging ^ digging ^ expected_digging) &&
                expected_walk_left === (expected_walk_left ^ walk_left ^ expected_walk_left) &&
                expected_walk_right === (expected_walk_right ^ walk_right ^ expected_walk_right)) begin
                $display("PASS");
                $display("  Outputs: aaah=%b, digging=%b, walk_left=%b, walk_right=%b",
                         aaah, digging, walk_left, walk_right);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aaah=%b, digging=%b, walk_left=%b, walk_right=%b",
                         expected_aaah, expected_digging, expected_walk_left, expected_walk_right);
                $display("  Got:      aaah=%b, digging=%b, walk_left=%b, walk_right=%b",
                         aaah, digging, walk_left, walk_right);
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
        $dumpvars(0,areset, bump_left, bump_right, clk, dig, ground, aaah, digging, walk_left, walk_right);
    end

endmodule
