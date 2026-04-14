`timescale 1ns/1ps

module viterbi_decoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] input_bits;
    reg reset;
    wire [1:0] decoded_bits;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    viterbi_decoder dut (
        .clk(clk),
        .input_bits(input_bits),
        .reset(reset),
        .decoded_bits(decoded_bits),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            input_bits = 2'b00;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: All-zero sequence");
            reset_dut();
            repeat (10) begin
                input_bits = 2'b00;
                @(posedge clk);
            end

            wait(valid == 1);
            #1;

            check_outputs(2'b00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Alternating sequence 1-0");
            reset_dut();
            input_bits = 2'b11;
            @(posedge clk);
            input_bits = 2'b10;
            @(posedge clk);
            input_bits = 2'b11;
            @(posedge clk);

            wait(valid == 1);

            #1;


            check_outputs(2'b10, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Error correction - Single bit flip");
            reset_dut();
            input_bits = 2'b10;
            @(posedge clk);
            input_bits = 2'b01;
            @(posedge clk);
            repeat (5) @(posedge clk);

            wait(valid == 1);


            #1;



            check_outputs(2'b10, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: All-ones sequence");
            reset_dut();
            repeat (8) begin
                input_bits = 2'b11;
                @(posedge clk);
            end
            wait(valid == 1);
            #1;

            check_outputs(2'b11, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Reset mid-operation");
            reset_dut();
            input_bits = 2'b11;
            @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;
            input_bits = 2'b00;
            @(posedge clk);

            #1;


            check_outputs(2'b00, 1'b0);
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
        input [1:0] expected_decoded_bits;
        input expected_valid;
        begin
            if (expected_decoded_bits === (expected_decoded_bits ^ decoded_bits ^ expected_decoded_bits) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: decoded_bits=%h, valid=%b",
                         decoded_bits, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decoded_bits=%h, valid=%b",
                         expected_decoded_bits, expected_valid);
                $display("  Got:      decoded_bits=%h, valid=%b",
                         decoded_bits, valid);
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
        $dumpvars(0,clk, input_bits, reset, decoded_bits, valid);
    end

endmodule
