`timescale 1ns/1ps

module rle_encoder_tb;

    // Testbench signals (sequential circuit)
    reg bit_in;
    reg clk;
    reg done;
    reg reset;
    wire [7:0] encoded_bit;
    wire [7:0] run_length;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rle_encoder dut (
        .bit_in(bit_in),
        .clk(clk),
        .done(done),
        .reset(reset),
        .encoded_bit(encoded_bit),
        .run_length(run_length),
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
            bit_in = 0;
            done = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase001: Two 0s");
            test_num = test_num + 1;
            reset_dut();
            bit_in = 0; @(posedge clk);
            bit_in = 0; @(posedge clk);
            done = 1;   @(posedge clk);
            #2 #1;
 check_outputs(8'h00, 8'h02, 1'b1);
            done = 0;   @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase002: Three 1s");
            test_num = test_num + 1;
            reset_dut();
            bit_in = 1; @(posedge clk);
            bit_in = 1; @(posedge clk);
            bit_in = 1; @(posedge clk);
            done = 1;   @(posedge clk);
            #2 #1;
 check_outputs(8'h01, 8'h03, 1'b1);
            done = 0;   @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase003: Single bit 1");
            test_num = test_num + 1;
            reset_dut();
            bit_in = 1; @(posedge clk);
            done = 1;   @(posedge clk);
            #2 #1;
 check_outputs(8'h01, 8'h01, 1'b1);
            done = 0;   @(posedge clk);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase004: Sequence 001111");
            test_num = test_num + 1;
            reset_dut();
            bit_in = 0; @(posedge clk);
            bit_in = 0; @(posedge clk);
            bit_in = 1; @(posedge clk);
            bit_in = 1; @(posedge clk);
            bit_in = 1; @(posedge clk);
            bit_in = 1; @(posedge clk);
            done = 1;   @(posedge clk);
            #2 #1;
 check_outputs(8'h01, 8'h04, 1'b1);
            done = 0;   @(posedge clk);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase005: Run of ten 0s");
            test_num = test_num + 1;
            reset_dut();
            repeat(10) begin
                bit_in = 0; @(posedge clk);
            end
            done = 1;   @(posedge clk);
            #2 #1;
 check_outputs(8'h00, 8'h0A, 1'b1);
            done = 0;   @(posedge clk);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase006: Sequence 1110 -> Done");
            test_num = test_num + 1;
            reset_dut();
            bit_in = 1; @(posedge clk);
            bit_in = 1; @(posedge clk);
            bit_in = 1; @(posedge clk);
            bit_in = 0; @(posedge clk);
            done = 1;   @(posedge clk);
            #2 #1;
 check_outputs(8'h00, 8'h01, 1'b1);
            done = 0;   @(posedge clk);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rle_encoder Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [7:0] expected_encoded_bit;
        input [7:0] expected_run_length;
        input expected_valid;
        begin
            if (expected_encoded_bit === (expected_encoded_bit ^ encoded_bit ^ expected_encoded_bit) &&
                expected_run_length === (expected_run_length ^ run_length ^ expected_run_length) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: encoded_bit=%h, run_length=%h, valid=%b",
                         encoded_bit, run_length, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_bit=%h, run_length=%h, valid=%b",
                         expected_encoded_bit, expected_run_length, expected_valid);
                $display("  Got:      encoded_bit=%h, run_length=%h, valid=%b",
                         encoded_bit, run_length, valid);
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
        $dumpvars(0,bit_in, clk, done, reset, encoded_bit, run_length, valid);
    end

endmodule
