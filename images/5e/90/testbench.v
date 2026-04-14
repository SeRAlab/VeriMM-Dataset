`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg CLK;
    reg [3:0] LOAD;
    reg RESET;
    reg UP_DOWN;
    wire [7:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CLK(CLK),
        .LOAD(LOAD),
        .RESET(RESET),
        .UP_DOWN(UP_DOWN),
        .product(product)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RESET = 1;
            A = 0;
            B = 0;
            LOAD = 0;
            UP_DOWN = 0;
            @(posedge CLK);
            #2;
            RESET = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Multiply and Increment", test_num);
            reset_dut();
            A = 4'd3; B = 4'd2; UP_DOWN = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(8'd6);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multiple Increments", test_num);
            reset_dut();
            A = 4'd2; B = 4'd4; UP_DOWN = 1;
            repeat(3) @(posedge CLK);
            #2;
            #1;

            check_outputs(8'd24);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Decrement Wrap-around", test_num);
            reset_dut();
            A = 4'd5; B = 4'd2; UP_DOWN = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(8'd150);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Zero Multiplication", test_num);
            reset_dut();
            A = 4'd0; B = 4'd7; UP_DOWN = 1;
            repeat(2) @(posedge CLK);
            #2;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: 8-bit Truncation", test_num);
            reset_dut();
            A = 4'd15; B = 4'd15; UP_DOWN = 1;
            repeat(2) @(posedge CLK);
            #2;
            #1;

            check_outputs(8'd194);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multiple Decrements", test_num);
            reset_dut();
            A = 4'd10; B = 4'd1; UP_DOWN = 0;
            repeat(2) @(posedge CLK);
            #2;
            #1;

            check_outputs(8'd140);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [7:0] expected_product;
        begin
            if (expected_product === (expected_product ^ product ^ expected_product)) begin
                $display("PASS");
                $display("  Outputs: product=%h",
                         product);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: product=%h",
                         expected_product);
                $display("  Got:      product=%h",
                         product);
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
        $dumpvars(0,A, B, CLK, LOAD, RESET, UP_DOWN, product);
    end

endmodule
