`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] CTRL;
    reg [15:0] DATA;
    reg [3:0] SHIFT;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CTRL(CTRL),
        .DATA(DATA),
        .SHIFT(SHIFT),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Logical Left Shift (LSL) - 16'h0001 << 4", test_num);
        CTRL = 2'b00;
        DATA = 16'h0001;
        SHIFT = 4'd4;
        #1;

        check_outputs(16'h0010);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Logical Left Shift (LSL) - 16'h8001 << 1", test_num);
        CTRL = 2'b00;
        DATA = 16'h8001;
        SHIFT = 4'd1;
        #1;

        check_outputs(16'h0002);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Logical Right Shift (LSR) - 16'h8000 >> 4", test_num);
        CTRL = 2'b01;
        DATA = 16'h8000;
        SHIFT = 4'd4;
        #1;

        check_outputs(16'h0800);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Logical Right Shift (LSR) - 16'hFFFF >> 15", test_num);
        CTRL = 2'b01;
        DATA = 16'hFFFF;
        SHIFT = 4'd15;
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Arithmetic Right Shift (ASR) - Positive 16'h4000 >>> 4", test_num);
        CTRL = 2'b10;
        DATA = 16'h4000;
        SHIFT = 4'd4;
        #1;

        check_outputs(16'h0400);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Arithmetic Right Shift (ASR) - Negative 16'h8000 >>> 4", test_num);
        CTRL = 2'b10;
        DATA = 16'h8000;
        SHIFT = 4'd4;
        #1;

        check_outputs(16'hF800);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Arithmetic Right Shift (ASR) - Negative 16'hF000 >>> 8", test_num);
        CTRL = 2'b10;
        DATA = 16'hF000;
        SHIFT = 4'd8;
        #1;

        check_outputs(16'hFFF0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Rotate Right (ROR) - 16'h1234 ROR 4", test_num);
        CTRL = 2'b11;
        DATA = 16'h1234;
        SHIFT = 4'd4;
        #1;

        check_outputs(16'h4123);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Rotate Right (ROR) - 16'h0001 ROR 1", test_num);
        CTRL = 2'b11;
        DATA = 16'h0001;
        SHIFT = 4'd1;
        #1;

        check_outputs(16'h8000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: All Modes - Shift 0", test_num);
        DATA = 16'hABCD;
        SHIFT = 4'd0;

        CTRL = 2'b00; #1;
        CTRL = 2'b01; #1;
        CTRL = 2'b10; #1;
        CTRL = 2'b11; #1;

        #1;


        check_outputs(16'hABCD);
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
