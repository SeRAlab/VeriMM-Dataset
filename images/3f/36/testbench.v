`timescale 1ns/1ps

module branch_predictor_tb;

    // Testbench signals (sequential circuit)
    reg actual_outcome;
    reg [3:0] branch_addr;
    reg clk;
    reg reset;
    wire predicted_outcome;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    branch_predictor dut (
        .actual_outcome(actual_outcome),
        .branch_addr(branch_addr),
        .clk(clk),
        .reset(reset),
        .predicted_outcome(predicted_outcome)
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
            branch_addr = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial prediction after reset", test_num);
            reset_dut();
            branch_addr = 4'hA;
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Transition from Not Taken to Taken", test_num);
            reset_dut();
            branch_addr = 4'h1;
            actual_outcome = 1'b1;


            repeat (3) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Transition from Taken to Not Taken", test_num);
            reset_dut();
            branch_addr = 4'h2;


            actual_outcome = 1'b1;
            repeat (3) @(posedge clk);


            actual_outcome = 1'b0;
            repeat (3) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Saturation at Strongly Taken", test_num);
            reset_dut();
            branch_addr = 4'h3;
            actual_outcome = 1'b1;
            repeat (10) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Saturation at Strongly Not Taken", test_num);
            reset_dut();
            branch_addr = 4'h4;
            actual_outcome = 1'b0;
            repeat (10) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Address Independence", test_num);
            reset_dut();


            branch_addr = 4'h8;
            actual_outcome = 1'b1;
            repeat (3) @(posedge clk);


            branch_addr = 4'h9;
            actual_outcome = 1'b0;
            repeat (3) @(posedge clk);


            branch_addr = 4'h8;
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Hysteresis check", test_num);
            reset_dut();
            branch_addr = 4'hF;


            actual_outcome = 1'b1;
            repeat (3) @(posedge clk);


            actual_outcome = 1'b0;
            @(posedge clk);

            #1;

            #1;


            check_outputs(1'b1);
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
        input expected_predicted_outcome;
        begin
            if (expected_predicted_outcome === (expected_predicted_outcome ^ predicted_outcome ^ expected_predicted_outcome)) begin
                $display("PASS");
                $display("  Outputs: predicted_outcome=%b",
                         predicted_outcome);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: predicted_outcome=%b",
                         expected_predicted_outcome);
                $display("  Got:      predicted_outcome=%b",
                         predicted_outcome);
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
        $dumpvars(0,actual_outcome, branch_addr, clk, reset, predicted_outcome);
    end

endmodule
