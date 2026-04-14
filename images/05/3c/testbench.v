`timescale 1ns/1ps

module viterbi_decoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] encoded_input;
    reg input_valid;
    reg reset;
    wire [7:0] decoded_output;
    wire output_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    viterbi_decoder dut (
        .clk(clk),
        .encoded_input(encoded_input),
        .input_valid(input_valid),
        .reset(reset),
        .decoded_output(decoded_output),
        .output_valid(output_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            reset = 1;
            input_valid = 0;
            encoded_input = 2'b00;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task send_encoded_block;

        input [15:0] encoded_stream;
        integer i;
        begin
            for (i = 0; i < 8; i = i + 1) begin
                encoded_input = encoded_stream[i*2 +: 2];
                input_valid = 1;
                @(posedge clk);
                #1;
            end
            input_valid = 0;


            fork : wait_for_valid
                begin
                    wait(output_valid === 1);
                end
                begin
                    repeat (100) @(posedge clk);
                    $display("Timeout waiting for output_valid");
                end
            join_any
            disable wait_for_valid;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: All Zeros Sequence", test_num);
            reset_dut();
            send_encoded_block(16'b00_00_00_00_00_00_00_00);
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Data 8'h0B Encoding", test_num);
            reset_dut();
            send_encoded_block(16'b00_00_11_10_00_01_01_11);
            #1;

            check_outputs(8'h0B, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Single Bit Error Correction", test_num);
            reset_dut();


            send_encoded_block(16'b00_00_11_10_00_01_01_10);
            #1;

            check_outputs(8'h0B, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: All Ones Sequence", test_num);
            reset_dut();

            send_encoded_block(16'b10_10_10_10_10_10_01_11);
            #1;

            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Multiple Bit Errors", test_num);
            reset_dut();


            send_encoded_block(16'b00_00_01_10_00_00_01_11);
            #1;

            check_outputs(8'h0B, 1'b1);
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
        input [7:0] expected_decoded_output;
        input expected_output_valid;
        begin
            if (expected_decoded_output === (expected_decoded_output ^ decoded_output ^ expected_decoded_output) &&
                expected_output_valid === (expected_output_valid ^ output_valid ^ expected_output_valid)) begin
                $display("PASS");
                $display("  Outputs: decoded_output=%h, output_valid=%b",
                         decoded_output, output_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decoded_output=%h, output_valid=%b",
                         expected_decoded_output, expected_output_valid);
                $display("  Got:      decoded_output=%h, output_valid=%b",
                         decoded_output, output_valid);
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
        $dumpvars(0,clk, encoded_input, input_valid, reset, decoded_output, output_valid);
    end

endmodule
