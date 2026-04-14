`timescale 1ns/1ps

module branch_predictor_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] branch_outcome;
    reg clk;
    reg reset;
    wire [1:0] counter;
    wire prediction;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    branch_predictor dut (
        .branch_outcome(branch_outcome),
        .clk(clk),
        .reset(reset),
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
            branch_outcome = 2'b00;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Reset State", test_num);
            reset_dut();
            #1;

            check_outputs(2'b01, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Weakly Not Taken -> Weakly Taken", test_num);
            reset_dut();
            branch_outcome = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Saturate at Strongly Taken", test_num);
            reset_dut();
            branch_outcome = 2'b01;
            @(posedge clk);
            #1;
            branch_outcome = 2'b01;
            @(posedge clk);
            #1;
            branch_outcome = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b11, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Saturate at Strongly Not Taken", test_num);
            reset_dut();
            branch_outcome = 2'b00;
            @(posedge clk);
            #1;
            branch_outcome = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transition from Strongly Taken to Strongly Not Taken", test_num);
            reset_dut();

            branch_outcome = 2'b01;
            @(posedge clk);
            #1;
            branch_outcome = 2'b01;
            @(posedge clk);
            #1;

            branch_outcome = 2'b00;
            @(posedge clk);
            #1;
            branch_outcome = 2'b00;
            @(posedge clk);
            #1;
            branch_outcome = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Hysteresis check", test_num);
            reset_dut();
            branch_outcome = 2'b01;
            @(posedge clk);
            #1;
            branch_outcome = 2'b00;
            @(posedge clk);
            #1;
            branch_outcome = 2'b01;
            @(posedge clk);
            #1;
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
        $dumpvars(0,branch_outcome, clk, reset, counter, prediction);
    end

endmodule
