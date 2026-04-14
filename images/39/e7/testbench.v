`timescale 1ns/1ps

module rnn_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] hidden_state_prev;
    reg [7:0] input_data;
    reg reset;
    wire [7:0] hidden_state_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rnn_cell dut (
        .clk(clk),
        .hidden_state_prev(hidden_state_prev),
        .input_data(input_data),
        .reset(reset),
        .hidden_state_out(hidden_state_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            hidden_state_prev = 8'd0;
            input_data = 8'd0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Zero Sum (0 + 0)", test_num);
            reset_dut();
            hidden_state_prev = 8'h00;
            input_data = 8'h00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Opposing Values (10 + -10)", test_num);
            reset_dut();
            hidden_state_prev = 8'd10;
            input_data = -8'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Positive Sum (5 + 5)", test_num);
            reset_dut();
            hidden_state_prev = 8'd5;
            input_data = 8'd5;
            @(posedge clk);
            #1;


            if (hidden_state_out > 8'h00 && hidden_state_out[7] == 0) begin
                pass_count = pass_count + 1;
                $display("PASS: Positive value received: %h", hidden_state_out);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Expected positive value, got %h", hidden_state_out);
            end
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Negative Sum (-10 + -5)", test_num);
            reset_dut();
            hidden_state_prev = -8'd10;
            input_data = -8'd5;
            @(posedge clk);
            #1;

            if (hidden_state_out[7] == 1) begin
                pass_count = pass_count + 1;
                $display("PASS: Negative value received: %h", hidden_state_out);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Expected negative value, got %h", hidden_state_out);
            end
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Positive Saturation", test_num);
            reset_dut();
            hidden_state_prev = 8'h7F;
            input_data = 8'h7F;
            @(posedge clk);
            #1;


            if (hidden_state_out > 8'h10) begin
                pass_count = pass_count + 1;
                $display("PASS: Saturated positive: %h", hidden_state_out);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Expected saturation, got %h", hidden_state_out);
            end
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Negative Saturation", test_num);
            reset_dut();
            hidden_state_prev = 8'h80;
            input_data = 8'h80;
            @(posedge clk);
            #1;

            if (hidden_state_out[7] == 1 && hidden_state_out < 8'hF0) begin
                pass_count = pass_count + 1;
                $display("PASS: Saturated negative: %h", hidden_state_out);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Expected negative saturation, got %h", hidden_state_out);
            end
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
        input [7:0] expected_hidden_state_out;
        begin
            if (expected_hidden_state_out === (expected_hidden_state_out ^ hidden_state_out ^ expected_hidden_state_out)) begin
                $display("PASS");
                $display("  Outputs: hidden_state_out=%h",
                         hidden_state_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hidden_state_out=%h",
                         expected_hidden_state_out);
                $display("  Got:      hidden_state_out=%h",
                         hidden_state_out);
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
        $dumpvars(0,clk, hidden_state_prev, input_data, reset, hidden_state_out);
    end

endmodule
