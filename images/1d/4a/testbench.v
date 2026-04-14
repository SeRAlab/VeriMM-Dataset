`timescale 1ns/1ps

module matrix_factorization_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [71:0] input_matrix;
    reg rst;
    reg start;
    wire done;
    wire [23:0] item_factors;
    wire [23:0] user_factors;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_factorization dut (
        .clk(clk),
        .input_matrix(input_matrix),
        .rst(rst),
        .start(start),
        .done(done),
        .item_factors(item_factors),
        .user_factors(user_factors)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            input_matrix = 72'h0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %03d: All-Zero Matrix", test_num);
            reset_dut();

            input_matrix = 72'h0;
            start = 1;
            @(posedge clk);
            #1 start = 0;


            wait(done == 1);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 24'h000000, 24'h000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %03d: Rank-1 Symmetric Matrix", test_num);
            reset_dut();

            input_matrix = 72'h090603_060402_030201;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done == 1);
            @(posedge clk);



            #1;




            check_outputs(1'b1, 24'h030201, 24'h030201);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %03d: Sparse Rank-1 Matrix", test_num);
            reset_dut();

            input_matrix = 72'h00000C_000008_000004;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done == 1);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 24'h000004, 24'h030201);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %03d: Diagonal Matrix (Approximation)", test_num);
            reset_dut();

            input_matrix = 72'h050000_000500_000005;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done == 1);
            @(posedge clk);



            if (done == 1 && (item_factors != 0 || user_factors != 0)) begin
                 $display("PASS: Logic completed with non-zero factors.");
                 pass_count = pass_count + 1;
            end else begin
                 $display("FAIL: Logic failed to compute factors for diagonal matrix.");
                 fail_count = fail_count + 1;
            end
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
        input expected_done;
        input [23:0] expected_item_factors;
        input [23:0] expected_user_factors;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_item_factors === (expected_item_factors ^ item_factors ^ expected_item_factors) &&
                expected_user_factors === (expected_user_factors ^ user_factors ^ expected_user_factors)) begin
                $display("PASS");
                $display("  Outputs: done=%b, item_factors=%h, user_factors=%h",
                         done, item_factors, user_factors);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, item_factors=%h, user_factors=%h",
                         expected_done, expected_item_factors, expected_user_factors);
                $display("  Got:      done=%b, item_factors=%h, user_factors=%h",
                         done, item_factors, user_factors);
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
        $dumpvars(0,clk, input_matrix, rst, start, done, item_factors, user_factors);
    end

endmodule
