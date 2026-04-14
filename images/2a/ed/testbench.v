`timescale 1ns/1ps

module branch_predictor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg predicted;
    reg reset;
    reg taken;
    wire [1:0] counter;
    wire prediction;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    branch_predictor dut (
        .clk(clk),
        .predicted(predicted),
        .reset(reset),
        .taken(taken),
        .counter(counter),
        .prediction(prediction)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            taken = 0;
            predicted = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\n--- Testcase 001: Reset State ---");
            reset_dut();

            #1;


            check_outputs(2'b00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\n--- Testcase 002: Increment (0 -> 1) ---");
            reset_dut();
            predicted = prediction;
            taken = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("\n--- Testcase 003: Increment (1 -> 2) ---");
            reset_dut();

            predicted = prediction; taken = 1; @(posedge clk); #1;

            predicted = prediction; taken = 1; @(posedge clk); #1;
            #1;

            check_outputs(2'b10, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\n--- Testcase 004: Increment (2 -> 3) ---");
            reset_dut();

            repeat(2) begin predicted = prediction; taken = 1; @(posedge clk); #1; end

            predicted = prediction; taken = 1; @(posedge clk); #1;
            #1;

            check_outputs(2'b11, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("\n--- Testcase 005: Saturation at 3 ---");
            reset_dut();

            repeat(3) begin predicted = prediction; taken = 1; @(posedge clk); #1; end

            predicted = prediction; taken = 1; @(posedge clk); #1;
            #1;

            check_outputs(2'b11, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("\n--- Testcase 006: Decrement (3 -> 2) ---");
            reset_dut();

            repeat(3) begin predicted = prediction; taken = 1; @(posedge clk); #1; end

            predicted = prediction; taken = 0; @(posedge clk); #1;
            #1;

            check_outputs(2'b10, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("\n--- Testcase 007: Decrement and Saturation at 0 ---");
            reset_dut();

            predicted = prediction; taken = 1; @(posedge clk); #1;

            predicted = prediction; taken = 0; @(posedge clk); #1;

            predicted = prediction; taken = 0; @(posedge clk); #1;
            #1;

            check_outputs(2'b00, 1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("\n--- Testcase 008: Complex Sequence ---");
            reset_dut();


            predicted = prediction; taken = 1; @(posedge clk); #1;
            predicted = prediction; taken = 1; @(posedge clk); #1;
            predicted = prediction; taken = 0; @(posedge clk); #1;
            predicted = prediction; taken = 1; @(posedge clk); #1;
            #1;

            check_outputs(2'b10, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("branch_predictor Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [1:0] expected_counter;
        input expected_prediction;
        begin
            if (expected_counter === (expected_counter ^ counter ^ expected_counter) &&
                expected_prediction === (expected_prediction ^ prediction ^ expected_prediction)) begin
                $display("PASS");
                $display("  Outputs: counter=%h, prediction=%b",
                         counter, prediction);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter=%h, prediction=%b",
                         expected_counter, expected_prediction);
                $display("  Got:      counter=%h, prediction=%b",
                         counter, prediction);
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
        $dumpvars(0,clk, predicted, reset, taken, counter, prediction);
    end

endmodule
