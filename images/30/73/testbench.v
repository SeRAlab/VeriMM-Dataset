`timescale 1ns/1ps

module viterbi_decoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] encoded_bits;
    reg reset;
    reg valid;
    wire [1:0] decoded_bits;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    viterbi_decoder dut (
        .clk(clk),
        .encoded_bits(encoded_bits),
        .reset(reset),
        .valid(valid),
        .decoded_bits(decoded_bits),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            valid = 0;
            encoded_bits = 2'b00;
            @(posedge clk);
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: All Zeros Sequence");
            reset_dut();
            valid = 1;
            repeat(4) begin
                encoded_bits = 2'b00;
                @(posedge clk);
            end
            valid = 0;

            wait(valid_out == 1);
            #1;

            check_outputs(2'b00, 1'b1);
            @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: All Ones Sequence");
            reset_dut();
            valid = 1;
            encoded_bits = 2'b11; @(posedge clk);
            encoded_bits = 2'b01; @(posedge clk);
            encoded_bits = 2'b10; @(posedge clk);
            encoded_bits = 2'b10; @(posedge clk);
            valid = 0;
            wait(valid_out == 1);
            #1;

            check_outputs(2'b11, 1'b1);
            @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Alternating Sequence (1,0,1,0)");
            reset_dut();
            valid = 1;
            encoded_bits = 2'b11; @(posedge clk);
            encoded_bits = 2'b10; @(posedge clk);
            encoded_bits = 2'b00; @(posedge clk);
            encoded_bits = 2'b10; @(posedge clk);
            valid = 0;
            wait(valid_out == 1);
            #1;

            check_outputs(2'b10, 1'b1);
            @(posedge clk);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Error Correction (Single Bit Flip)");
            reset_dut();
            valid = 1;
            encoded_bits = 2'b00; @(posedge clk);
            encoded_bits = 2'b01; @(posedge clk);
            encoded_bits = 2'b00; @(posedge clk);
            encoded_bits = 2'b00; @(posedge clk);
            valid = 0;
            wait(valid_out == 1);

            #1;


            check_outputs(2'b00, 1'b1);
            @(posedge clk);
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
        input [1:0] expected_decoded_bits;
        input expected_valid_out;
        begin
            if (expected_decoded_bits === (expected_decoded_bits ^ decoded_bits ^ expected_decoded_bits) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: decoded_bits=%h, valid_out=%b",
                         decoded_bits, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decoded_bits=%h, valid_out=%b",
                         expected_decoded_bits, expected_valid_out);
                $display("  Got:      decoded_bits=%h, valid_out=%b",
                         decoded_bits, valid_out);
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
        $dumpvars(0,clk, encoded_bits, reset, valid, decoded_bits, valid_out);
    end

endmodule
