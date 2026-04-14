`timescale 1ns/1ps

module binary_subtractor_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg borrow_in;
    reg clk;
    wire borrow_out;
    wire [3:0] diff;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_subtractor dut (
        .a(a),
        .b(b),
        .borrow_in(borrow_in),
        .clk(clk),
        .borrow_out(borrow_out),
        .diff(diff)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 4'b0000;
            b = 4'b0000;
            borrow_in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Simple subtraction (4 - 2 - 0)", test_num);
            a = 4'b0100; b = 4'b0010; borrow_in = 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 4'b0010);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test %0d: Subtraction with borrow_in (6 - 5 - 1)", test_num);
            a = 4'b0110; b = 4'b0101; borrow_in = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 4'b0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test %0d: Underflow case (2 - 5 - 0)", test_num);
            a = 4'b0010; b = 4'b0101; borrow_in = 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 4'b1101);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test %0d: Zero minus Zero with borrow_in (0 - 0 - 1)", test_num);
            a = 4'b0000; b = 4'b0000; borrow_in = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 4'b1111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test %0d: Max values (15 - 15 - 1)", test_num);
            a = 4'b1111; b = 4'b1111; borrow_in = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 4'b1111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Test %0d: Zero result (10 - 10 - 0)", test_num);
            a = 4'd10; b = 4'd10; borrow_in = 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 4'b0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_subtractor Testbench");
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
        input expected_borrow_out;
        input [3:0] expected_diff;
        begin
            if (expected_borrow_out === (expected_borrow_out ^ borrow_out ^ expected_borrow_out) &&
                expected_diff === (expected_diff ^ diff ^ expected_diff)) begin
                $display("PASS");
                $display("  Outputs: borrow_out=%b, diff=%h",
                         borrow_out, diff);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: borrow_out=%b, diff=%h",
                         expected_borrow_out, expected_diff);
                $display("  Got:      borrow_out=%b, diff=%h",
                         borrow_out, diff);
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
        $dumpvars(0,a, b, borrow_in, clk, borrow_out, diff);
    end

endmodule
