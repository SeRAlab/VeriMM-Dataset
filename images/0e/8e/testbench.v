`timescale 1ns/1ps

module branch_predictor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg taken;
    wire [1:0] prediction;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    branch_predictor dut (
        .clk(clk),
        .reset(reset),
        .taken(taken),
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
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Initial Reset State");
            reset_dut();
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Transition to and saturate at Strongly Taken");
            reset_dut();
            taken = 1; @(posedge clk);
            taken = 1; @(posedge clk);
            taken = 1; @(posedge clk);
            #1 #1;
 check_outputs(2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Transition to and saturate at Strongly Not Taken");
            reset_dut();
            taken = 0; @(posedge clk);
            taken = 0; @(posedge clk);
            #1 #1;
 check_outputs(2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Sweep from bottom to top");
            reset_dut();
            taken = 0; @(posedge clk);
            taken = 1; @(posedge clk);
            taken = 1; @(posedge clk);
            taken = 1; @(posedge clk);
            #1 #1;
 check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Oscillating Taken/Not-Taken");
            reset_dut();
            taken = 1; @(posedge clk);
            taken = 0; @(posedge clk);
            taken = 1; @(posedge clk);
            taken = 0; @(posedge clk);
            #1 #1;
 check_outputs(2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Decrement from Strongly Taken");
            reset_dut();
            taken = 1; @(posedge clk);
            taken = 1; @(posedge clk);
            taken = 0; @(posedge clk);
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
        input [1:0] expected_prediction;
        begin
            if (expected_prediction === (expected_prediction ^ prediction ^ expected_prediction)) begin
                $display("PASS");
                $display("  Outputs: prediction=%h",
                         prediction);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: prediction=%h",
                         expected_prediction);
                $display("  Got:      prediction=%h",
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
        $dumpvars(0,clk, reset, taken, prediction);
    end

endmodule
