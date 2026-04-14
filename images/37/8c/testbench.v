`timescale 1ns/1ps

module branch_predictor_tb;

    // Testbench signals (sequential circuit)
    reg actual_outcome;
    reg branch_prediction;
    reg clk;
    reg reset;
    wire prediction;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    branch_predictor dut (
        .actual_outcome(actual_outcome),
        .branch_prediction(branch_prediction),
        .clk(clk),
        .reset(reset),
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
            actual_outcome = 0;
            branch_prediction = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transition from 00 to 10 (Predict Taken)", test_num);
            reset_dut();


            actual_outcome = 1'b1;
            branch_prediction = 1'b0;
            @(posedge clk);
            #1;


            actual_outcome = 1'b1;
            branch_prediction = 1'b0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Saturate at Strongly Taken", test_num);
            reset_dut();


            repeat(4) begin
                actual_outcome = 1'b1;
                branch_prediction = 1'b1;
                @(posedge clk);
                #1;
            end


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transition from 11 to 01 (Predict Not Taken)", test_num);
            reset_dut();


            repeat(3) begin
                actual_outcome = 1'b1;
                @(posedge clk); #1;
            end


            actual_outcome = 1'b0;
            @(posedge clk); #1;


            actual_outcome = 1'b0;
            @(posedge clk); #1;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Saturate at Strongly Not Taken", test_num);
            reset_dut();


            repeat(2) begin
                actual_outcome = 1'b0;
                @(posedge clk); #1;
            end


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Hysteresis (Stay in Taken region)", test_num);
            reset_dut();


            actual_outcome = 1'b1; @(posedge clk); #1;
            actual_outcome = 1'b1; @(posedge clk); #1;
            actual_outcome = 1'b1; @(posedge clk); #1;


            actual_outcome = 1'b0;
            @(posedge clk); #1;


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Toggling", test_num);
            reset_dut();


            actual_outcome = 1'b1; @(posedge clk); #1;


            actual_outcome = 1'b1; @(posedge clk); #1;


            actual_outcome = 1'b0; @(posedge clk); #1;


            #1;



            check_outputs(1'b0);
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
        input expected_prediction;
        begin
            if (expected_prediction === (expected_prediction ^ prediction ^ expected_prediction)) begin
                $display("PASS");
                $display("  Outputs: prediction=%b",
                         prediction);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: prediction=%b",
                         expected_prediction);
                $display("  Got:      prediction=%b",
                         prediction);
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
        $dumpvars(0,actual_outcome, branch_prediction, clk, reset, prediction);
    end

endmodule
