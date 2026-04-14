`timescale 1ns/1ps

module matrix_factorization_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [71:0] ratings;
    wire [23:0] item_features;
    wire [23:0] user_features;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_factorization dut (
        .clk(clk),
        .enable(enable),
        .ratings(ratings),
        .item_features(item_features),
        .user_features(user_features)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            ratings = 72'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Zero Matrix", test_num);
            reset_dut();

            ratings = 72'h0;
            enable = 1;


            repeat(50) @(posedge clk);

            #1;


            check_outputs(24'h000000, 24'h000000);
            enable = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Uniform Matrix (Perfect Square)", test_num);
            reset_dut();


            ratings = 72'h040404_040404_040404;
            enable = 1;

            repeat(100) @(posedge clk);


            #1;



            check_outputs(24'h020202, 24'h020202);
            enable = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: User Bias Matrix", test_num);
            reset_dut();

            ratings = 72'h010101_020202_030303;
            enable = 1;

            repeat(100) @(posedge clk);


            #1;



            check_outputs(24'h010101, 24'h010203);
            enable = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Item Bias Matrix", test_num);
            reset_dut();

            ratings = 72'h010204_010204_010204;
            enable = 1;

            repeat(100) @(posedge clk);


            #1;



            check_outputs(24'h010204, 24'h010101);
            enable = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mixed Rank-1 Matrix", test_num);
            reset_dut();




            ratings = 72'h060204_0C0408_030102;
            enable = 1;

            repeat(150) @(posedge clk);


            #1;



            check_outputs(24'h030102, 24'h020401);
            enable = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("matrix_factorization Testbench");
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
        input [23:0] expected_item_features;
        input [23:0] expected_user_features;
        begin
            if (expected_item_features === (expected_item_features ^ item_features ^ expected_item_features) &&
                expected_user_features === (expected_user_features ^ user_features ^ expected_user_features)) begin
                $display("PASS");
                $display("  Outputs: item_features=%h, user_features=%h",
                         item_features, user_features);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: item_features=%h, user_features=%h",
                         expected_item_features, expected_user_features);
                $display("  Got:      item_features=%h, user_features=%h",
                         item_features, user_features);
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
        $dumpvars(0,clk, enable, ratings, item_features, user_features);
    end

endmodule
