`timescale 1ns/1ps

module viterbi_decoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [1:0] input_bits;
    reg reset;
    wire done;
    wire [1:0] output_bits;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    viterbi_decoder dut (
        .clk(clk),
        .enable(enable),
        .input_bits(input_bits),
        .reset(reset),
        .done(done),
        .output_bits(output_bits)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            enable = 0;
            input_bits = 2'b00;
            repeat(2) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial Reset and Idle", test_num);
            reset_dut();
            #1;

            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Step Decoding (Input 2'b11)", test_num);
            reset_dut();

            enable = 1;
            input_bits = 2'b11;
            @(posedge clk);
            enable = 0;


            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b1, 2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequence Decoding (10 -> 01 -> 11)", test_num);
            reset_dut();

            enable = 1;
            input_bits = 2'b10; @(posedge clk);
            input_bits = 2'b01; @(posedge clk);
            input_bits = 2'b11; @(posedge clk);
            enable = 0;


            while (!done) @(posedge clk);


            #1;



            check_outputs(1'b1, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable Signal Gating", test_num);
            reset_dut();

            enable = 0;
            input_bits = 2'b11;
            repeat(3) @(posedge clk);


            #1;



            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Back-to-back Operation", test_num);


            reset_dut();
            enable = 1;
            input_bits = 2'b01; @(posedge clk);
            enable = 0;
            repeat(2) @(posedge clk);


            reset_dut();
            enable = 1;
            input_bits = 2'b00; @(posedge clk);
            enable = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 2'b00);
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
        input expected_done;
        input [1:0] expected_output_bits;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_output_bits === (expected_output_bits ^ output_bits ^ expected_output_bits)) begin
                $display("PASS");
                $display("  Outputs: done=%b, output_bits=%h",
                         done, output_bits);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, output_bits=%h",
                         expected_done, expected_output_bits);
                $display("  Got:      done=%b, output_bits=%h",
                         done, output_bits);
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
        $dumpvars(0,clk, enable, input_bits, reset, done, output_bits);
    end

endmodule
