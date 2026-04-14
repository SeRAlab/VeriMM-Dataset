`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [7:0] C;
    reg clock;
    wire [9:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .clock(clock),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            A = 8'd0;
            B = 8'd0;
            C = 8'd0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: All Zeros (0 + 0 + 0)", test_num);
            reset_dut();
            A = 8'd0; B = 8'd0; C = 8'd0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(10'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: All Maximum (255 + 255 + 255)", test_num);
            reset_dut();
            A = 8'd255; B = 8'd255; C = 8'd255;
            @(posedge clock);
            #1;
            #1;

            check_outputs(10'd765);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Simple Small Values (10 + 20 + 30)", test_num);
            reset_dut();
            A = 8'd10; B = 8'd20; C = 8'd30;
            @(posedge clock);
            #1;
            #1;

            check_outputs(10'd60);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: 8-bit Boundary (127 + 127 + 1)", test_num);
            reset_dut();
            A = 8'd127; B = 8'd127; C = 8'd1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(10'd255);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: 9-bit Result (255 + 1 + 0)", test_num);
            reset_dut();
            A = 8'd255; B = 8'd1; C = 8'd0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(10'd256);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Alternating Bit Patterns (0xAA + 0x55 + 0x01)", test_num);
            reset_dut();
            A = 8'hAA; B = 8'h55; C = 8'h01;
            @(posedge clock);
            #1;
            #1;

            check_outputs(10'h100);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Mid-range (100 + 150 + 200)", test_num);
            reset_dut();
            A = 8'd100; B = 8'd150; C = 8'd200;
            @(posedge clock);
            #1;
            #1;

            check_outputs(10'd450);
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
        input [9:0] expected_sum;
        begin
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
        $dumpvars(0,A, B, C, clock, sum);
    end

endmodule
