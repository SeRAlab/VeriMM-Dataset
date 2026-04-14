`timescale 1ns/1ps

module MatrixFactorization_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] item_matrix;
    reg [15:0] user_matrix;
    wire [15:0] predicted_ratings;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    MatrixFactorization dut (
        .item_matrix(item_matrix),
        .user_matrix(user_matrix),
        .predicted_ratings(predicted_ratings)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero Inputs", test_num);
            item_matrix = 16'h0000;
            user_matrix = 16'h0000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Multiplicative Identity", test_num);
            item_matrix = 16'h0001;
            user_matrix = 16'h0042;
            #1;

            check_outputs(16'h0042);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Small Values", test_num);
            item_matrix = 16'd12;
            user_matrix = 16'd5;
            #1;

            check_outputs(16'd60);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Power of Two Calculation", test_num);
            item_matrix = 16'd256;
            user_matrix = 16'd10;
            #1;

            check_outputs(16'd2560);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum Result within 16-bit (65025)", test_num);
            item_matrix = 16'd255;
            user_matrix = 16'd255;
            #1;

            check_outputs(16'd65025);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Overflow Handling (Truncation to 16-bit)", test_num);


            item_matrix = 16'd1000;
            user_matrix = 16'd100;
            #1;

            check_outputs(16'h86A0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Large Latent Factor Input", test_num);
            item_matrix = 16'hFFFF;
            user_matrix = 16'h0001;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("MatrixFactorization Testbench");
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
        input [15:0] expected_predicted_ratings;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_predicted_ratings === (expected_predicted_ratings ^ predicted_ratings ^ expected_predicted_ratings)) begin
                $display("PASS");
                $display("  Outputs: predicted_ratings=%h",
                         predicted_ratings);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: predicted_ratings=%h",
                         expected_predicted_ratings);
                $display("  Got:      predicted_ratings=%h",
                         predicted_ratings);
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
