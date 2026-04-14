`timescale 1ns/1ps

module viterbi_decoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] received_bits;
    reg rst;
    reg start;
    wire [3:0] decoded_output;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    viterbi_decoder dut (
        .clk(clk),
        .received_bits(received_bits),
        .rst(rst),
        .start(start),
        .decoded_output(decoded_output),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            received_bits = 2'b00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case %0d: Clear Channel - Sequence 0000", test_num);

            @(posedge clk);
            start = 1;
            received_bits = 2'b00;
            @(posedge clk);
            start = 0;
            received_bits = 2'b00;
            @(posedge clk);
            received_bits = 2'b00;
            @(posedge clk);
            received_bits = 2'b00;
            @(posedge clk);
            received_bits = 2'b00;

            wait(done);
            #1;

            check_outputs(4'b0000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case %0d: Clear Channel - Sequence 1111", test_num);

            @(posedge clk);
            start = 1;
            received_bits = 2'b11;
            @(posedge clk);
            start = 0;
            received_bits = 2'b01;
            @(posedge clk);
            received_bits = 2'b10;
            @(posedge clk);
            received_bits = 2'b10;
            @(posedge clk);

            wait(done);
            #1;

            check_outputs(4'b1111, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case %0d: Clear Channel - Sequence 1010", test_num);

            @(posedge clk);
            start = 1;
            received_bits = 2'b11;
            @(posedge clk);
            start = 0;
            received_bits = 2'b10;
            @(posedge clk);
            received_bits = 2'b00;
            @(posedge clk);
            received_bits = 2'b10;
            @(posedge clk);

            wait(done);
            #1;

            check_outputs(4'b1010, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case %0d: Error Correction - 1 bit flip in 0000", test_num);

            @(posedge clk);
            start = 1;
            received_bits = 2'b01;
            @(posedge clk);
            start = 0;
            received_bits = 2'b00;
            @(posedge clk);
            received_bits = 2'b00;
            @(posedge clk);
            received_bits = 2'b00;
            @(posedge clk);

            wait(done);
            #1;

            check_outputs(4'b0000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case %0d: Error Correction - 1 bit flip in 1011", test_num);

            @(posedge clk);
            start = 1;
            received_bits = 2'b11;
            @(posedge clk);
            start = 0;
            received_bits = 2'b11;
            @(posedge clk);
            received_bits = 2'b00;
            @(posedge clk);
            received_bits = 2'b01;
            @(posedge clk);

            wait(done);
            #1;

            check_outputs(4'b1011, 1'b1);
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
        input [3:0] expected_decoded_output;
        input expected_done;
        begin
            if (expected_decoded_output === (expected_decoded_output ^ decoded_output ^ expected_decoded_output) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: decoded_output=%h, done=%b",
                         decoded_output, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decoded_output=%h, done=%b",
                         expected_decoded_output, expected_done);
                $display("  Got:      decoded_output=%h, done=%b",
                         decoded_output, done);
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
        $dumpvars(0,clk, received_bits, rst, start, decoded_output, done);
    end

endmodule
