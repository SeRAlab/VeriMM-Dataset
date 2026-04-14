`timescale 1ns/1ps

module MatrixFactorization_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] item_idx;
    reg [7:0] rating;
    reg reset;
    reg [3:0] user_idx;
    reg valid;
    wire [7:0] predicted_rating;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    MatrixFactorization dut (
        .clk(clk),
        .item_idx(item_idx),
        .rating(rating),
        .reset(reset),
        .user_idx(user_idx),
        .valid(valid),
        .predicted_rating(predicted_rating)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            valid = 0;
            user_idx = 0;
            item_idx = 0;
            rating = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %03d: Initial Reset State", test_num);
            reset_dut();

            user_idx = 4'h5;
            item_idx = 4'hA;
            valid = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %03d: Single Training Step", test_num);
            reset_dut();


            user_idx = 4'h1;
            item_idx = 4'h1;
            rating = 8'hFF;
            valid = 1;
            @(posedge clk);


            valid = 0;
            @(posedge clk);
            #1;


            if (predicted_rating > 8'h00)
                pass_count = pass_count + 1;
            else begin
                $display("FAIL: Prediction stayed at 0 after training.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Running Testcase %03d: Convergence on Target", test_num);
            reset_dut();

            user_idx = 4'h2;
            item_idx = 4'h2;
            rating = 8'h80;
            valid = 1;


            for (i = 0; i < 20; i = i + 1) begin
                @(posedge clk);
            end

            valid = 0;
            @(posedge clk);
            #1;



            if (predicted_rating >= 8'h40)
                pass_count = pass_count + 1;
            else begin
                $display("FAIL: Prediction %h failed to converge towards 80", predicted_rating);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %03d: Index Independence", test_num);
            reset_dut();


            user_idx = 4'h1;
            item_idx = 4'h1;
            rating = 8'hFF;
            valid = 1;
            repeat(5) @(posedge clk);


            valid = 0;
            user_idx = 4'h5;
            item_idx = 4'h5;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00);
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
        input [7:0] expected_predicted_rating;
        begin
            if (expected_predicted_rating === (expected_predicted_rating ^ predicted_rating ^ expected_predicted_rating)) begin
                $display("PASS");
                $display("  Outputs: predicted_rating=%h",
                         predicted_rating);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: predicted_rating=%h",
                         expected_predicted_rating);
                $display("  Got:      predicted_rating=%h",
                         predicted_rating);
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
        $dumpvars(0,clk, item_idx, rating, reset, user_idx, valid, predicted_rating);
    end

endmodule
