`timescale 1ns/1ps

module matrix_factorization_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] ratings;
    wire [7:0] item_features;
    wire [7:0] user_features;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_factorization dut (
        .ratings(ratings),
        .item_features(item_features),
        .user_features(user_features)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Zero Matrix", test_num);

            ratings = 16'h0000;

            #1;


            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Identity-like Rank-1 Matrix (All Ones)", test_num);


            ratings = 16'h1111;

            #1;


            check_outputs(8'h11, 8'h11);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Perfect Factorization (Symmetric)", test_num);


            ratings = 16'h4221;

            #1;


            check_outputs(8'h21, 8'h21);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Perfect Factorization (Asymmetric)", test_num);



            ratings = 16'h6342;

            #1;


            check_outputs(8'h21, 8'h32);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Higher Value Factorization", test_num);



            ratings = 16'h9C68;

            #1;


            check_outputs(8'h34, 8'h32);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Prime-based Factorization", test_num);



            ratings = 16'hFA96;

            #1;


            check_outputs(8'h32, 8'h53);
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
        input [7:0] expected_item_features;
        input [7:0] expected_user_features;
        begin
            #1; // Small delay for combinational logic to settle
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

endmodule
