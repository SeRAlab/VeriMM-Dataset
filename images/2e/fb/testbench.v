`timescale 1ns/1ps

module rnn_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] hidden_state_prev;
    reg [7:0] input_val;
    reg reset;
    wire [7:0] hidden_state_next;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rnn_cell dut (
        .clk(clk),
        .hidden_state_prev(hidden_state_prev),
        .input_val(input_val),
        .reset(reset),
        .hidden_state_next(hidden_state_next)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            input_val = 0;
            hidden_state_prev = 0;
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
            $display("Running Testcase001: Reset logic...");
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase002: Simple addition (Positive)...");
            reset_dut();
            input_val = 8'd10;
            hidden_state_prev = 8'd20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase003: ReLU clipping negative values...");
            reset_dut();

            input_val = 8'hF1;
            hidden_state_prev = 8'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase004: Sum resulting in exactly zero...");
            reset_dut();
            input_val = 8'hF1;
            hidden_state_prev = 8'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase005: Large positive values...");
            reset_dut();
            input_val = 8'sd60;
            hidden_state_prev = 8'sd67;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'sd127);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Running Testcase006: Sequential dependency...");
            reset_dut();


            input_val = 8'd10;
            hidden_state_prev = 8'd0;
            @(posedge clk);
            #1;


            hidden_state_prev = hidden_state_next;
            input_val = 8'd5;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'd15);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rnn_cell Testbench");
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
        input [7:0] expected_hidden_state_next;
        begin
            if (expected_hidden_state_next === (expected_hidden_state_next ^ hidden_state_next ^ expected_hidden_state_next)) begin
                $display("PASS");
                $display("  Outputs: hidden_state_next=%h",
                         hidden_state_next);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hidden_state_next=%h",
                         expected_hidden_state_next);
                $display("  Got:      hidden_state_next=%h",
                         hidden_state_next);
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
        $dumpvars(0,clk, hidden_state_prev, input_val, reset, hidden_state_next);
    end

endmodule
