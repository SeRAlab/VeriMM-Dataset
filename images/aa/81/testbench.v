`timescale 1ns/1ps

module compare_numbers_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] binary_num1;
    reg [7:0] binary_num2;
    reg clk;
    reg reset;
    wire is_equal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    compare_numbers_module dut (
        .binary_num1(binary_num1),
        .binary_num2(binary_num2),
        .clk(clk),
        .reset(reset),
        .is_equal(is_equal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            binary_num1 = 8'd0;
            binary_num2 = 8'd0;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Equality at Zero", test_num);
            reset_dut();
            binary_num1 = 8'd0;
            binary_num2 = 8'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Inequality (num1 < num2)", test_num);
            reset_dut();
            binary_num1 = 8'd10;
            binary_num2 = 8'd20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Equality at 255", test_num);
            reset_dut();
            binary_num1 = 8'd255;
            binary_num2 = 8'd255;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max vs Min Inequality", test_num);
            reset_dut();
            binary_num1 = 8'd255;
            binary_num2 = 8'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Bit Difference", test_num);
            reset_dut();
            binary_num1 = 8'b10101010;
            binary_num2 = 8'b10101011;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Equality with Arbitrary Value (123)", test_num);
            reset_dut();
            binary_num1 = 8'd123;
            binary_num2 = 8'd123;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset Priority (Equal inputs while Reset=1)", test_num);
            reset_dut();

            @(negedge clk);
            binary_num1 = 8'd50;
            binary_num2 = 8'd50;
            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);

            @(negedge clk);
            reset = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("compare_numbers_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input expected_is_equal;
        begin
            if (expected_is_equal === (expected_is_equal ^ is_equal ^ expected_is_equal)) begin
                $display("PASS");
                $display("  Outputs: is_equal=%b",
                         is_equal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: is_equal=%b",
                         expected_is_equal);
                $display("  Got:      is_equal=%b",
                         is_equal);
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
        $dumpvars(0,binary_num1, binary_num2, clk, reset, is_equal);
    end

endmodule
