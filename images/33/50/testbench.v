`timescale 1ns/1ps

module branch_predictor_tb;

    // Testbench signals (sequential circuit)
    reg branch_outcome;
    reg clk;
    reg reset;
    wire [1:0] prediction_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    branch_predictor dut (
        .branch_outcome(branch_outcome),
        .clk(clk),
        .reset(reset),
        .prediction_state(prediction_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            branch_outcome = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
            test_num = test_num + 1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase 001: Check reset state");
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Testcase 002: SNT (00) to WNT (01)");
            branch_outcome = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Testcase 003: SNT (00) to WT (10)");
            branch_outcome = 1;
            @(posedge clk);
            #1;
            branch_outcome = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Testcase 004: SNT (00) to ST (11)");
            repeat(3) begin
                branch_outcome = 1;
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Testcase 005: High Saturation at ST (11)");
            repeat(5) begin
                branch_outcome = 1;
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            $display("Testcase 006: ST (11) down to WT (10)");

            repeat(3) begin
                branch_outcome = 1;
                @(posedge clk);
                #1;
            end

            branch_outcome = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            $display("Testcase 007: ST (11) down to WNT (01)");
            repeat(3) begin
                branch_outcome = 1;
                @(posedge clk);
                #1;
            end
            repeat(2) begin
                branch_outcome = 0;
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            $display("Testcase 008: ST (11) down to SNT (00)");
            repeat(3) begin
                branch_outcome = 1;
                @(posedge clk);
                #1;
            end
            repeat(3) begin
                branch_outcome = 0;
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            $display("Testcase 009: Low Saturation at SNT (00)");
            repeat(3) begin
                branch_outcome = 0;
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            $display("Testcase 010: Zig-zag SNT -> WNT -> SNT");
            branch_outcome = 1;
            @(posedge clk);
            #1;
            branch_outcome = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00);
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
        testcase009();
        testcase010();
        
        
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
        input [1:0] expected_prediction_state;
        begin
            if (expected_prediction_state === (expected_prediction_state ^ prediction_state ^ expected_prediction_state)) begin
                $display("PASS");
                $display("  Outputs: prediction_state=%h",
                         prediction_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: prediction_state=%h",
                         expected_prediction_state);
                $display("  Got:      prediction_state=%h",
                         prediction_state);
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
        $dumpvars(0,branch_outcome, clk, reset, prediction_state);
    end

endmodule
