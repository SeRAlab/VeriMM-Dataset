`timescale 1ns/1ps

module matrix_factorization_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [199:0] ratings;
    reg reset;
    wire [119:0] item_features;
    wire [119:0] user_features;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_factorization dut (
        .clk(clk),
        .ratings(ratings),
        .reset(reset),
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
            $display("Resetting DUT...");
            reset = 1;
            ratings = 200'b0;
            repeat (5) @(posedge clk);
            reset = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All-Zero Ratings Matrix", test_num);
            reset_dut();

            ratings = 200'h0;


            repeat (100) @(posedge clk);


            #1;



            check_outputs(120'h0, 120'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Uniform Low Ratings (All 0x01)", test_num);
            reset_dut();


            ratings = {25{8'h01}};

            repeat (100) @(posedge clk);





            #1;






            check_outputs(120'h010101010101010101010101010101, 120'h010101010101010101010101010101);
        end
        endtask

    task testcase003;

        reg [199:0] diag_matrix;
        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Diagonal Dominant Matrix", test_num);
            reset_dut();

            diag_matrix = 0;


            diag_matrix[7:0]     = 8'hFF;
            diag_matrix[55:48]   = 8'hFF;
            diag_matrix[103:96]  = 8'hFF;
            diag_matrix[151:144] = 8'hFF;
            diag_matrix[199:192] = 8'hFF;

            ratings = diag_matrix;

            repeat (200) @(posedge clk);



            #1;




            check_outputs(120'h0F00000F00000F00000F00000F0000, 120'h100000100000100000100000100000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Block Matrix Pattern", test_num);
            reset_dut();


            ratings = 0;
            ratings[7:0]   = 8'hA0;
            ratings[15:8]  = 8'hA0;
            ratings[47:40] = 8'hA0;
            ratings[55:48] = 8'hA0;

            repeat (100) @(posedge clk);



            #1;




            check_outputs(120'hA0A000000000000000000000000000, 120'h010100000000000000000000000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum Ratings Saturation", test_num);
            reset_dut();

            ratings = {200{1'b1}};

            repeat (150) @(posedge clk);


            #1;



            check_outputs(120'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, 120'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
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
        input [119:0] expected_item_features;
        input [119:0] expected_user_features;
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
        $dumpvars(0,clk, ratings, reset, item_features, user_features);
    end

endmodule
