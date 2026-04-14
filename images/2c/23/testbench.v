`timescale 1ns/1ps

module rle_encoder_tb;

    // Testbench signals (sequential circuit)
    reg bit_in;
    reg clk;
    reg reset;
    wire bit_out;
    wire [3:0] count;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rle_encoder dut (
        .bit_in(bit_in),
        .clk(clk),
        .reset(reset),
        .bit_out(bit_out),
        .count(count),
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
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Run of 5 Zeros", test_num);
        repeat(5) begin
            bit_in = 0;
            @(posedge clk);
            #1;
        end
        bit_in = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 4'd5, 1'b1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Run of 3 Ones", test_num);
        repeat(3) begin
            bit_in = 1;
            @(posedge clk);
            #1;
        end
        bit_in = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 4'd3, 1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum Run Length (15 Ones)", test_num);
        repeat(15) begin
            bit_in = 1;
            @(posedge clk);
            #1;
        end
        bit_in = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 4'd15, 1'b1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Single Bit Run (1)", test_num);
        bit_in = 1;
        @(posedge clk);
        #1;
        bit_in = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 4'd1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Consecutive Runs (Checking second run of 4 zeros)", test_num);

        repeat(2) begin
            bit_in = 1;
            @(posedge clk);
            #1;
        end

        repeat(4) begin
            bit_in = 0;
            @(posedge clk);
            #1;
        end

        bit_in = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 4'd4, 1'b1);
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
        input expected_bit_out;
        input [3:0] expected_count;
        input expected_valid;
        begin
            if (expected_bit_out === (expected_bit_out ^ bit_out ^ expected_bit_out) &&
                expected_count === (expected_count ^ count ^ expected_count) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: bit_out=%b, count=%h, valid=%b",
                         bit_out, count, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bit_out=%b, count=%h, valid=%b",
                         expected_bit_out, expected_count, expected_valid);
                $display("  Got:      bit_out=%b, count=%h, valid=%b",
                         bit_out, count, valid);
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
        $dumpvars(0,bit_in, clk, reset, bit_out, count, valid);
    end

endmodule
