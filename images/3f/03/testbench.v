`timescale 1ns/1ps

module viterbi_decoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] encoded_bits;
    reg reset;
    reg valid;
    wire [3:0] decoded_bits;
    wire done;

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
        .done(done)
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
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        integer i;
        begin
            test_num = 1;
            $display("\nTestcase %0d: All Zeros Sequence", test_num);
            reset_dut();


            for (i = 0; i < 4; i = i + 1) begin
                valid = 1;
                encoded_bits = 2'b00;
                @(posedge clk);
            end
            valid = 0;


            while (!done) @(posedge clk);

            #1;


            check_outputs(4'b0000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: All Ones Sequence", test_num);
            reset_dut();

            valid = 1;
            encoded_bits = 2'b11; @(posedge clk);
            encoded_bits = 2'b01; @(posedge clk);
            encoded_bits = 2'b11; @(posedge clk);
            encoded_bits = 2'b11; @(posedge clk);
            valid = 0;

            while (!done) @(posedge clk);

            #1;


            check_outputs(4'b1111, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Error Correction (One bit flip)", test_num);
            reset_dut();

            valid = 1;
            encoded_bits = 2'b01; @(posedge clk);
            encoded_bits = 2'b00; @(posedge clk);
            encoded_bits = 2'b00; @(posedge clk);
            encoded_bits = 2'b00; @(posedge clk);
            valid = 0;

            while (!done) @(posedge clk);


            #1;



            check_outputs(4'b0000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Pattern 1010 Sequence", test_num);
            reset_dut();

            valid = 1;
            encoded_bits = 2'b11; @(posedge clk);
            encoded_bits = 2'b11; @(posedge clk);
            encoded_bits = 2'b00; @(posedge clk);
            encoded_bits = 2'b11; @(posedge clk);
            valid = 0;

            while (!done) @(posedge clk);

            #1;


            check_outputs(4'b1010, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Heavy Error Correction", test_num);
            reset_dut();

            valid = 1;
            encoded_bits = 2'b00; @(posedge clk);
            encoded_bits = 2'b01; @(posedge clk);
            encoded_bits = 2'b11; @(posedge clk);
            encoded_bits = 2'b11; @(posedge clk);
            valid = 0;

            while (!done) @(posedge clk);


            #1;



            check_outputs(4'b1111, 1'b1);
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
        input [3:0] expected_decoded_bits;
        input expected_done;
        begin
            if (expected_decoded_bits === (expected_decoded_bits ^ decoded_bits ^ expected_decoded_bits) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: decoded_bits=%h, done=%b",
                         decoded_bits, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decoded_bits=%h, done=%b",
                         expected_decoded_bits, expected_done);
                $display("  Got:      decoded_bits=%h, done=%b",
                         decoded_bits, done);
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
        $dumpvars(0,clk, encoded_bits, reset, valid, decoded_bits, done);
    end

endmodule
