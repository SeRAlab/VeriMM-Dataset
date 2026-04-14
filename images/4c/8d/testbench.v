`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in;
    reg [4:0] shift_amt;
    reg [1:0] shift_type;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .shift_amt(shift_amt),
        .shift_type(shift_type),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Logical Left Shift (LSL) - 32'h00000001 << 1", test_num);
            in = 32'h00000001;
            shift_amt = 5'd1;
            shift_type = 2'b00;
            #1;

            check_outputs(32'h00000002);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Logical Left Shift (LSL) - 32'h00000001 << 31", test_num);
            in = 32'h00000001;
            shift_amt = 5'd31;
            shift_type = 2'b00;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Logical Left Shift (LSL) - 32'hFFFFFFFF << 4", test_num);
            in = 32'hFFFFFFFF;
            shift_amt = 5'd4;
            shift_type = 2'b00;
            #1;

            check_outputs(32'hFFFFFFF0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Arithmetic Right Shift (ASR) - 32'h80000000 >>> 1 (Negative)", test_num);
            in = 32'h80000000;
            shift_amt = 5'd1;
            shift_type = 2'b01;
            #1;

            check_outputs(32'hC0000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Arithmetic Right Shift (ASR) - 32'h7FFFFFFF >>> 1 (Positive)", test_num);
            in = 32'h7FFFFFFF;
            shift_amt = 5'd1;
            shift_type = 2'b01;
            #1;

            check_outputs(32'h3FFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Arithmetic Right Shift (ASR) - 32'h80000000 >>> 31", test_num);
            in = 32'h80000000;
            shift_amt = 5'd31;
            shift_type = 2'b01;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Logical Right Shift (LSR) - 32'h80000000 >> 1", test_num);
            in = 32'h80000000;
            shift_amt = 5'd1;
            shift_type = 2'b10;
            #1;

            check_outputs(32'h40000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Logical Right Shift (LSR) - 32'hFFFFFFFF >> 31", test_num);
            in = 32'hFFFFFFFF;
            shift_amt = 5'd31;
            shift_type = 2'b10;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Default case (Unshifted) - type 2'b11", test_num);
            in = 32'hA5A5A5A5;
            shift_amt = 5'd15;
            shift_type = 2'b11;
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift amount 0 check (LSL)", test_num);
            in = 32'h12345678;
            shift_amt = 5'd0;
            shift_type = 2'b00;
            #1;

            check_outputs(32'h12345678);
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
        input [31:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
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

endmodule
