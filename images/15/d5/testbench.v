`timescale 1ns/1ps

module pipelined_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] in_a;
    reg [4:0] in_b;
    reg [4:0] in_c;
    reg [4:0] in_d;
    reg [4:0] in_e;
    reg reset;
    wire [4:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_processor dut (
        .clk(clk),
        .in_a(in_a),
        .in_b(in_b),
        .in_c(in_c),
        .in_d(in_d),
        .in_e(in_e),
        .reset(reset),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in_a = 0; in_b = 0; in_c = 0; in_d = 0; in_e = 0;
            @(posedge clk);
            #1 reset = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            in_a = 5'd10; in_b = 5'd5; in_c = 5'd3; in_d = 5'h1F; in_e = 5'd0;
            @(posedge clk);

            repeat(5) @(posedge clk);
            #1;
            $display("Test Case 001: Basic Arithmetic");
            #1;

            check_outputs(calc_expected(10, 5, 3, 31, 0));
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            in_a = 5'd5; in_b = 5'd5; in_c = 5'd2; in_d = 5'd0; in_e = 5'd4;
            @(posedge clk);
            repeat(5) @(posedge clk);
            #1;
            $display("Test Case 002: Logic Dominance");
            #1;

            check_outputs(calc_expected(5, 5, 2, 0, 4));
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            in_a = 5'd1; in_b = 5'd1; in_c = 5'd5; in_d = 5'h1F; in_e = 5'd0;
            @(posedge clk);
            repeat(5) @(posedge clk);
            #1;
            $display("Test Case 003: Wrap Around Subtraction");
            #1;

            check_outputs(calc_expected(1, 1, 5, 31, 0));
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            in_a = 5'd15; in_b = 5'd16; in_c = 5'd0; in_d = 5'h1F; in_e = 5'h1F;
            @(posedge clk);
            repeat(5) @(posedge clk);
            #1;
            $display("Test Case 004: Max Values");
            #1;

            check_outputs(calc_expected(15, 16, 0, 31, 31));
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipelined_processor Testbench");
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
        input [4:0] expected_out;
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
        $dumpvars(0,clk, in_a, in_b, in_c, in_d, in_e, reset, out);
    end

endmodule
