`timescale 1ns/1ps

module convolutional_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in_bit;
    reg reset;
    wire out_bit1;
    wire out_bit2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    convolutional_encoder dut (
        .clk(clk),
        .in_bit(in_bit),
        .reset(reset),
        .out_bit1(out_bit1),
        .out_bit2(out_bit2)
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
            in_bit = 0;
            @(posedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Sequence 10110");
            reset_dut();
            @(posedge clk); in_bit = 1;
            @(posedge clk); in_bit = 0;
            @(posedge clk); in_bit = 1;
            @(posedge clk); in_bit = 1;
            @(posedge clk); in_bit = 0;
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Sequence 00000");
            reset_dut();
            @(posedge clk); in_bit = 0;
            @(posedge clk); in_bit = 0;
            @(posedge clk); in_bit = 0;
            @(posedge clk); in_bit = 0;
            @(posedge clk); in_bit = 0;
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Sequence 11111");
            reset_dut();
            @(posedge clk); in_bit = 1;
            @(posedge clk); in_bit = 1;
            @(posedge clk); in_bit = 1;
            @(posedge clk); in_bit = 1;
            @(posedge clk); in_bit = 1;
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Sequence 11001");
            reset_dut();
            @(posedge clk); in_bit = 1;
            @(posedge clk); in_bit = 1;
            @(posedge clk); in_bit = 0;
            @(posedge clk); in_bit = 0;
            @(posedge clk); in_bit = 1;
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Sequence 01101");
            reset_dut();
            @(posedge clk); in_bit = 0;
            @(posedge clk); in_bit = 1;
            @(posedge clk); in_bit = 1;
            @(posedge clk); in_bit = 0;
            @(posedge clk); in_bit = 1;
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("convolutional_encoder Testbench");
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
        input expected_out_bit1;
        input expected_out_bit2;
        begin
            if (expected_out_bit1 === (expected_out_bit1 ^ out_bit1 ^ expected_out_bit1) &&
                expected_out_bit2 === (expected_out_bit2 ^ out_bit2 ^ expected_out_bit2)) begin
                $display("PASS");
                $display("  Outputs: out_bit1=%b, out_bit2=%b",
                         out_bit1, out_bit2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_bit1=%b, out_bit2=%b",
                         expected_out_bit1, expected_out_bit2);
                $display("  Got:      out_bit1=%b, out_bit2=%b",
                         out_bit1, out_bit2);
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
        $dumpvars(0,clk, in_bit, reset, out_bit1, out_bit2);
    end

endmodule
