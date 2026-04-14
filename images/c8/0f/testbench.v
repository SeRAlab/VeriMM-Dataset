`timescale 1ns/1ps

module add_five_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] in;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    add_five dut (
        .clk(clk),
        .in(in),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        in = 4'd0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        in = 4'd0;
        @(posedge clk);
        #1;
        $display("Test Case 001: Input 0");
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        in = 4'd5;
        @(posedge clk);
        #1;
        $display("Test Case 002: Input 5");
        #1;

        check_outputs(4'd10);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        in = 4'd10;
        @(posedge clk);
        #1;
        $display("Test Case 003: Input 10");
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        in = 4'd11;
        @(posedge clk);
        #1;
        $display("Test Case 004: Input 11 (Overflow to 0)");
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        in = 4'd15;
        @(posedge clk);
        #1;
        $display("Test Case 005: Input 15 (Overflow to 4)");
        #1;

        check_outputs(4'd4);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("add_five Testbench");
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
        input [3:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, in, out);
    end

endmodule
