`timescale 1ns/1ps

module branch_predictor_tb;

    // Testbench signals (sequential circuit)
    reg actual_outcome;
    reg clk;
    reg reset;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    branch_predictor dut (
        .actual_outcome(actual_outcome),
        .clk(clk),
        .reset(reset),
        .state(state)
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
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Transition to Strongly Taken (00 -> 11)");
            test_num = test_num + 1;
            reset_dut();

            actual_outcome = 1;
            @(posedge clk);
            actual_outcome = 1;
            @(posedge clk);
            actual_outcome = 1;
            @(posedge clk);

            #1 #1;
 check_outputs(2'b11);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Transition Strongly Taken to Strongly Not Taken (11 -> 00)");
            test_num = test_num + 1;
            reset_dut();


            actual_outcome = 1; @(posedge clk);
            actual_outcome = 1; @(posedge clk);
            actual_outcome = 1; @(posedge clk);


            actual_outcome = 0; @(posedge clk);
            actual_outcome = 0; @(posedge clk);
            actual_outcome = 0; @(posedge clk);

            #1 #1;
 check_outputs(2'b00);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Saturation at 11");
            test_num = test_num + 1;
            reset_dut();

            actual_outcome = 1; @(posedge clk);
            actual_outcome = 1; @(posedge clk);
            actual_outcome = 1; @(posedge clk);
            actual_outcome = 1; @(posedge clk);
            actual_outcome = 1; @(posedge clk);

            #1 #1;
 check_outputs(2'b11);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Saturation at 00");
            test_num = test_num + 1;
            reset_dut();

            actual_outcome = 0; @(posedge clk);
            actual_outcome = 0; @(posedge clk);

            #1 #1;
 check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Oscillation (00 -> 01 -> 10 -> 01)");
            test_num = test_num + 1;
            reset_dut();

            actual_outcome = 1; @(posedge clk);
            actual_outcome = 1; @(posedge clk);
            actual_outcome = 0; @(posedge clk);

            #1 #1;
 check_outputs(2'b01);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Reach Weakly Taken (10)");
            test_num = test_num + 1;
            reset_dut();

            actual_outcome = 1; @(posedge clk);
            actual_outcome = 1; @(posedge clk);

            #1 #1;
 check_outputs(2'b10);
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
        input [1:0] expected_state;
        begin
            if (expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: state=%h",
                         state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state=%h",
                         expected_state);
                $display("  Got:      state=%h",
                         state);
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
        $dumpvars(0,actual_outcome, clk, reset, state);
    end

endmodule
