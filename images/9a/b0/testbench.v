`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CLOCK;
    reg [3:0] INPUT0;
    reg [3:0] INPUT1;
    reg [7:0] MEMORY_DATA;
    reg RESET;
    wire [5:0] MEMORY_ADDR;
    wire [3:0] OUTPUT0;
    wire [3:0] OUTPUT1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLOCK(CLOCK),
        .INPUT0(INPUT0),
        .INPUT1(INPUT1),
        .MEMORY_DATA(MEMORY_DATA),
        .RESET(RESET),
        .MEMORY_ADDR(MEMORY_ADDR),
        .OUTPUT0(OUTPUT0),
        .OUTPUT1(OUTPUT1)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Basic Reset and Verification", test_num);
        RESET = 1;
        CLOCK = 0;
        INPUT0 = 4'h0;
        INPUT1 = 4'h0;
        MEMORY_DATA = 8'h00;
        #20;
        RESET = 0;
        #20;
        #1;

        check_outputs(6'd0, 4'd0, 4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Input changes with reset inactive", test_num);
        RESET = 1;
        #10;
        RESET = 0;
        #10;
        INPUT0 = 4'hA;
        INPUT1 = 4'h5;
        MEMORY_DATA = 8'hFF;
        #40;
        #1;

        check_outputs(6'd0, 4'd0, 4'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Active inputs during reset", test_num);
        RESET = 1;
        INPUT0 = 4'hF;
        INPUT1 = 4'hF;
        MEMORY_DATA = 8'hAA;
        #30;
        RESET = 0;
        #10;
        #1;

        check_outputs(6'd0, 4'd0, 4'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Long duration clock cycling with various inputs", test_num);
        RESET = 1;
        #10;
        RESET = 0;
        #10;
        repeat (10) begin
            @(posedge CLOCK);
            INPUT0 = $random;
            INPUT1 = $random;
            MEMORY_DATA = $random;
        end
        #1;

        check_outputs(6'd0, 4'd0, 4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Verify outputs remain zero at maximum input values", test_num);
        RESET = 1;
        #10;
        RESET = 0;
        #10;
        INPUT0 = 4'b1111;
        INPUT1 = 4'b1111;
        MEMORY_DATA = 8'b11111111;
        #50;
        #1;

        check_outputs(6'd0, 4'd0, 4'd0);
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
        input [5:0] expected_MEMORY_ADDR;
        input [3:0] expected_OUTPUT0;
        input [3:0] expected_OUTPUT1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_MEMORY_ADDR === (expected_MEMORY_ADDR ^ MEMORY_ADDR ^ expected_MEMORY_ADDR) &&
                expected_OUTPUT0 === (expected_OUTPUT0 ^ OUTPUT0 ^ expected_OUTPUT0) &&
                expected_OUTPUT1 === (expected_OUTPUT1 ^ OUTPUT1 ^ expected_OUTPUT1)) begin
                $display("PASS");
                $display("  Outputs: MEMORY_ADDR=%h, OUTPUT0=%h, OUTPUT1=%h",
                         MEMORY_ADDR, OUTPUT0, OUTPUT1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MEMORY_ADDR=%h, OUTPUT0=%h, OUTPUT1=%h",
                         expected_MEMORY_ADDR, expected_OUTPUT0, expected_OUTPUT1);
                $display("  Got:      MEMORY_ADDR=%h, OUTPUT0=%h, OUTPUT1=%h",
                         MEMORY_ADDR, OUTPUT0, OUTPUT1);
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
