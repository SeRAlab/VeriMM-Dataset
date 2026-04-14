`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg [3:0] shift;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .shift(shift),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift Value Zero (Direct reflect B)", test_num);
        A = 16'h0000;
        B = 16'hABCD;
        shift = 4'b0000;
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Logical Left Shift (MSB of shift set, shift=8)", test_num);
        A = 16'h0000;
        B = 16'h00FF;
        shift = 4'b1000;
        #1;

        check_outputs(16'hFF00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Logical Left Shift (MSB of shift set, shift=12)", test_num);
        A = 16'h0000;
        B = 16'h000F;
        shift = 4'b1100;
        #1;

        check_outputs(16'hF000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Logical Right Shift (MSB of shift not set, A[15]=0, shift=4)", test_num);
        A = 16'h0000;
        B = 16'hF000;
        shift = 4'b0100;
        #1;

        check_outputs(16'h0F00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Arithmetic Right Shift (MSB of shift not set, A[15]=1, shift=4, B[15]=1)", test_num);
        A = 16'h8000;
        B = 16'hF000;
        shift = 4'b0100;
        #1;

        check_outputs(16'hFF00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Logical Right Shift (MSB of shift not set, A[15]=0, shift=1)", test_num);
        A = 16'h0000;
        B = 16'h8001;
        shift = 4'b0001;
        #1;

        check_outputs(16'h4000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Arithmetic Right Shift (MSB of shift not set, A[15]=1, shift=1, B[15]=1)", test_num);
        A = 16'h8000;
        B = 16'h8001;
        shift = 4'b0001;
        #1;

        check_outputs(16'hC000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Arithmetic Right Shift (MSB of shift not set, A[15]=1, shift=2, B[15]=0)", test_num);
        A = 16'h8000;
        B = 16'h4000;
        shift = 4'b0010;
        #1;

        check_outputs(16'h1000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Logical Left Shift (Ignore A[15] when shift[3] is 1, shift=9)", test_num);
        A = 16'h8000;
        B = 16'h00FF;
        shift = 4'b1001;
        #1;

        check_outputs(16'hFE00);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Logical Right Shift (Max right shift range 7)", test_num);
        A = 16'h0000;
        B = 16'hFFFF;
        shift = 4'b0111;
        #1;

        check_outputs(16'h01FF);
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
        input [15:0] expected_out;
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
