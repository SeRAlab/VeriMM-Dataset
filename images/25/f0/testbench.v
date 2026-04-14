`timescale 1ns/1ps

module turbo_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg input_bit;
    reg reset;
    wire [1:0] encoded_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    turbo_encoder dut (
        .clk(clk),
        .input_bit(input_bit),
        .reset(reset),
        .encoded_out(encoded_out)
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
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Input 0");
            reset_dut();
            input_bit = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Input 1");
            reset_dut();
            input_bit = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(2'b11);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Sequence 1 -> 0");
            reset_dut();
            input_bit = 1; @(posedge clk);
            input_bit = 0; @(posedge clk);
            #1 #1;
 check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Sequence 1 -> 1");
            reset_dut();
            input_bit = 1; @(posedge clk);
            input_bit = 1; @(posedge clk);
            #1 #1;
 check_outputs(2'b10);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Sequence 1 -> 0 -> 1");
            reset_dut();
            input_bit = 1; @(posedge clk);
            input_bit = 0; @(posedge clk);
            input_bit = 1; @(posedge clk);
            #1 #1;
 check_outputs(2'b10);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Reset mid-stream");
            reset_dut();
            input_bit = 1; @(posedge clk);
            input_bit = 1; @(posedge clk);
            reset = 1;     @(posedge clk);
            #1 reset = 0;
            input_bit = 0; @(posedge clk);
            #1 #1;
 check_outputs(2'b00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("turbo_encoder Testbench");
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
        input [1:0] expected_encoded_out;
        begin
            if (expected_encoded_out === (expected_encoded_out ^ encoded_out ^ expected_encoded_out)) begin
                $display("PASS");
                $display("  Outputs: encoded_out=%h",
                         encoded_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_out=%h",
                         expected_encoded_out);
                $display("  Got:      encoded_out=%h",
                         encoded_out);
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
        $dumpvars(0,clk, input_bit, reset, encoded_out);
    end

endmodule
