`timescale 1ns/1ps

module rnn_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [1:0] hidden_state;
    reg [2:0] input_vector;
    reg reset;
    wire [1:0] new_hidden_state;
    wire [1:0] output_vector;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rnn_cell dut (
        .clk(clk),
        .enable(enable),
        .hidden_state(hidden_state),
        .input_vector(input_vector),
        .reset(reset),
        .new_hidden_state(new_hidden_state),
        .output_vector(output_vector)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            input_vector = 3'b000;
            hidden_state = 2'b00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reset Functionality", test_num);
            reset_dut();

            #1;


            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Basic Inference (Input=1, State=1)", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            input_vector = 3'b001;
            hidden_state = 2'b01;
            @(posedge clk);
            #1;


            #1;



            check_outputs(2'b10, 2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Enable Signal Logic (Enable=0)", test_num);
            reset_dut();
            @(posedge clk);
            enable = 0;
            input_vector = 3'b111;
            hidden_state = 2'b11;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Maximum Input Values (Input=7, State=3)", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            input_vector = 3'b111;
            hidden_state = 2'b11;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b11, 2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Zero Input Vector", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            input_vector = 3'b000;
            hidden_state = 2'b10;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b01, 2'b01);
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
        input [1:0] expected_new_hidden_state;
        input [1:0] expected_output_vector;
        begin
            if (expected_new_hidden_state === (expected_new_hidden_state ^ new_hidden_state ^ expected_new_hidden_state) &&
                expected_output_vector === (expected_output_vector ^ output_vector ^ expected_output_vector)) begin
                $display("PASS");
                $display("  Outputs: new_hidden_state=%h, output_vector=%h",
                         new_hidden_state, output_vector);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_hidden_state=%h, output_vector=%h",
                         expected_new_hidden_state, expected_output_vector);
                $display("  Got:      new_hidden_state=%h, output_vector=%h",
                         new_hidden_state, output_vector);
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
        $dumpvars(0,clk, enable, hidden_state, input_vector, reset, new_hidden_state, output_vector);
    end

endmodule
