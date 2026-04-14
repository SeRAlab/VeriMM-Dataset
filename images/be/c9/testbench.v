`timescale 1ns/1ps

module palindrome_check_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] binary_num;
    reg clk;
    reg reset;
    wire is_palindrome;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    palindrome_check_module dut (
        .binary_num(binary_num),
        .clk(clk),
        .reset(reset),
        .is_palindrome(is_palindrome)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        binary_num = 8'b0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: binary_num = 8'b00000000 (Palindrome)", test_num);
        reset_dut();
        binary_num = 8'b00000000;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: binary_num = 8'b11111111 (Palindrome)", test_num);
        reset_dut();
        binary_num = 8'b11111111;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: binary_num = 8'b10000001 (Palindrome)", test_num);
        reset_dut();
        binary_num = 8'b10000001;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: binary_num = 8'b10100101 (Palindrome)", test_num);
        reset_dut();
        binary_num = 8'b10100101;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: binary_num = 8'b11000011 (Palindrome)", test_num);
        reset_dut();
        binary_num = 8'b11000011;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: binary_num = 8'b10000000 (Not Palindrome)", test_num);
        reset_dut();
        binary_num = 8'b10000000;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: binary_num = 8'b11110000 (Not Palindrome)", test_num);
        reset_dut();
        binary_num = 8'b11110000;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: binary_num = 8'b10110111 (Not Palindrome)", test_num);
        reset_dut();
        binary_num = 8'b10110111;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: binary_num = 8'b10101010 (Not Palindrome)", test_num);
        reset_dut();
        binary_num = 8'b10101010;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: binary_num = 8'b10010110 (Not Palindrome)", test_num);
        reset_dut();
        binary_num = 8'b10010110;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("palindrome_check_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input expected_is_palindrome;
        begin
            if (expected_is_palindrome === (expected_is_palindrome ^ is_palindrome ^ expected_is_palindrome)) begin
                $display("PASS");
                $display("  Outputs: is_palindrome=%b",
                         is_palindrome);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: is_palindrome=%b",
                         expected_is_palindrome);
                $display("  Got:      is_palindrome=%b",
                         is_palindrome);
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
        $dumpvars(0,binary_num, clk, reset, is_palindrome);
    end

endmodule
