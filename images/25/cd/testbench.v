`timescale 1ns/1ps

module viterbi_decoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg input_bit;
    reg reset;
    reg valid_input;
    wire [1:0] decoded_output;
    wire [1:0] state_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    viterbi_decoder dut (
        .clk(clk),
        .input_bit(input_bit),
        .reset(reset),
        .valid_input(valid_input),
        .decoded_output(decoded_output),
        .state_output(state_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            input_bit = 0;
            valid_input = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        integer i;
        begin
            test_num = 1;
            $display("Testcase %03d: All-zero input sequence", test_num);
            reset_dut();
            valid_input = 1;

            for (i = 0; i < 10; i = i + 1) begin
                input_bit = 0;
                @(posedge clk);
            end
            valid_input = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            $display("Testcase %03d: All-ones input sequence", test_num);
            reset_dut();
            valid_input = 1;

            for (i = 0; i < 12; i = i + 1) begin
                input_bit = 1;
                @(posedge clk);
            end
            valid_input = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(2'b11, 2'b11);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase %03d: Alternating 1-0 input sequence", test_num);
            reset_dut();
            valid_input = 1;
            for (i = 0; i < 8; i = i + 1) begin
                input_bit = (i % 2 == 0) ? 1'b1 : 1'b0;
                @(posedge clk);
            end
            valid_input = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(2'b10, 2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Short burst of data (1100)", test_num);
            reset_dut();
            valid_input = 1;
            input_bit = 1; @(posedge clk);
            input_bit = 1; @(posedge clk);
            input_bit = 0; @(posedge clk);
            input_bit = 0; @(posedge clk);
            valid_input = 0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Reset mid-operation", test_num);
            reset_dut();
            valid_input = 1;
            input_bit = 1; @(posedge clk);
            input_bit = 1; @(posedge clk);

            reset = 1;
            @(posedge clk);
            reset = 0;
            input_bit = 0; @(posedge clk);
            input_bit = 0; @(posedge clk);
            valid_input = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("viterbi_decoder Testbench");
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
        input [1:0] expected_decoded_output;
        input [1:0] expected_state_output;
        begin
            if (expected_decoded_output === (expected_decoded_output ^ decoded_output ^ expected_decoded_output) &&
                expected_state_output === (expected_state_output ^ state_output ^ expected_state_output)) begin
                $display("PASS");
                $display("  Outputs: decoded_output=%h, state_output=%h",
                         decoded_output, state_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decoded_output=%h, state_output=%h",
                         expected_decoded_output, expected_state_output);
                $display("  Got:      decoded_output=%h, state_output=%h",
                         decoded_output, state_output);
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
        $dumpvars(0,clk, input_bit, reset, valid_input, decoded_output, state_output);
    end

endmodule
