`timescale 1ns/1ps

module matrix_factorization_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] interaction_matrix;
    reg rst;
    wire done;
    wire [7:0] item_factors;
    wire [7:0] user_factors;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_factorization dut (
        .clk(clk),
        .interaction_matrix(interaction_matrix),
        .rst(rst),
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
            interaction_matrix = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            interaction_matrix = 16'h0000;


            wait(done == 1);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            interaction_matrix = 16'h4824;

            wait(done == 1);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 8'h24, 8'h21);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            interaction_matrix = 16'h1111;

            wait(done == 1);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 8'h11, 8'h11);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            interaction_matrix = 16'h9362;

            wait(done == 1);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 8'h31, 8'h32);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            interaction_matrix = 16'hFFFF;


            repeat(5) @(posedge clk);


            rst = 1;
            @(posedge clk);
            rst = 0;


            if (done === 0) begin
                $display("Test Case 005: Reset mid-operation handled correctly.");
                pass_count = pass_count + 1;
            end else begin
                $display("Test Case 005: FAIL - done signal not cleared on reset.");
                fail_count = fail_count + 1;
            end
            test_num = test_num + 1;
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
        input expected_done;
        input [7:0] expected_item_factors;
        input [7:0] expected_user_factors;
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
        $dumpvars(0,clk, interaction_matrix, rst, done, item_factors, user_factors);
    end

endmodule
