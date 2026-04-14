`timescale 1ns/1ps

module rnn_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [3:0] input_vector;
    reg [3:0] prev_state;
    reg rst;
    wire [3:0] current_state;
    wire [3:0] output_vector;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rnn_cell dut (
        .clk(clk),
        .enable(enable),
        .input_vector(input_vector),
        .prev_state(prev_state),
        .rst(rst),
        .current_state(current_state),
        .output_vector(output_vector)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            enable = 0;
            input_vector = 4'd0;
            prev_state = 4'd0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Basic Addition (No Overflow)", test_num);
            reset_dut();
            input_vector = 4'd3;
            prev_state = 4'd4;
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd7, 4'd7);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Boundary Sum (15)", test_num);
            reset_dut();
            input_vector = 4'd10;
            prev_state = 4'd5;
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd15, 4'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Overflow Sum 16 (Result should be 0)", test_num);
            reset_dut();
            input_vector = 4'd8;
            prev_state = 4'd8;
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Overflow Sum 17 (Result should be 15)", test_num);
            reset_dut();
            input_vector = 4'd9;
            prev_state = 4'd8;
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd15, 4'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Max Input Overflow (30 -> 2)", test_num);
            reset_dut();
            input_vector = 4'd15;
            prev_state = 4'd15;
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd2, 4'd2);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Enable Control (Logic disabled)", test_num);
            reset_dut();
            input_vector = 4'd5;
            prev_state = 4'd5;
            enable = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Zero Addition", test_num);
            reset_dut();
            input_vector = 4'd0;
            prev_state = 4'd0;
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd0, 4'd0);
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
        input [3:0] expected_current_state;
        input [3:0] expected_output_vector;
        begin
            if (expected_current_state === (expected_current_state ^ current_state ^ expected_current_state) &&
                expected_output_vector === (expected_output_vector ^ output_vector ^ expected_output_vector)) begin
                $display("PASS");
                $display("  Outputs: current_state=%h, output_vector=%h",
                         current_state, output_vector);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_state=%h, output_vector=%h",
                         expected_current_state, expected_output_vector);
                $display("  Got:      current_state=%h, output_vector=%h",
                         current_state, output_vector);
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
        $dumpvars(0,clk, enable, input_vector, prev_state, rst, current_state, output_vector);
    end

endmodule
