`timescale 1ns/1ps

module rnn_inference_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg reset;
    wire hidden_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rnn_inference dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .hidden_state(hidden_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single High Input", test_num);
            reset_dut();
            data_in = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Low Input", test_num);
            reset_dut();
            data_in = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Double High Sequence", test_num);
            reset_dut();
            data_in = 1'b1; @(posedge clk); #1;
            data_in = 1'b1; @(posedge clk); #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Toggle Input Sequence", test_num);
            reset_dut();
            data_in = 1'b1; @(posedge clk); #1;
            data_in = 1'b0; @(posedge clk); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Three-cycle Sequence", test_num);
            reset_dut();
            data_in = 1'b1; @(posedge clk); #1;
            data_in = 1'b1; @(posedge clk); #1;
            data_in = 1'b1; @(posedge clk); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Leading Zeros Sequence", test_num);
            reset_dut();
            data_in = 1'b0; @(posedge clk); #1;
            data_in = 1'b0; @(posedge clk); #1;
            data_in = 1'b1; @(posedge clk); #1;
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
        $display("rnn_inference Testbench");
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
        input expected_hidden_state;
        begin
            if (expected_hidden_state === (expected_hidden_state ^ hidden_state ^ expected_hidden_state)) begin
                $display("PASS");
                $display("  Outputs: hidden_state=%b",
                         hidden_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hidden_state=%b",
                         expected_hidden_state);
                $display("  Got:      hidden_state=%b",
                         hidden_state);
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
        $dumpvars(0,clk, data_in, reset, hidden_state);
    end

endmodule
