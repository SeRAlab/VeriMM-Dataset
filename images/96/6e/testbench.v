`timescale 1ns/1ps

module alu_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] control;
    reg [31:0] operand1;
    reg [31:0] operand2;
    reg reset;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    alu dut (
        .clk(clk),
        .control(control),
        .operand1(operand1),
        .operand2(operand2),
        .reset(reset),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            operand1 = 0;
            operand2 = 0;
            control = 0;
            @(posedge clk);
            reset = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            operand1 = 32'd100;
            operand2 = 32'd250;
            control = 2'b00;
            @(posedge clk);
            #1;
            $display("Test Case 001: Addition (100 + 250)");
            #1;

            check_outputs(32'd350);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            operand1 = 32'hFFFFFFFF;
            operand2 = 32'h00000001;
            control = 2'b00;
            @(posedge clk);
            #1;
            $display("Test Case 002: Addition Overflow (0xFFFFFFFF + 1)");
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            operand1 = 32'd500;
            operand2 = 32'd150;
            control = 2'b01;
            @(posedge clk);
            #1;
            $display("Test Case 003: Subtraction (500 - 150)");
            #1;

            check_outputs(32'd350);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            operand1 = 32'd10;
            operand2 = 32'd20;
            control = 2'b01;
            @(posedge clk);
            #1;
            $display("Test Case 004: Subtraction Negative (10 - 20)");
            #1;

            check_outputs(32'hFFFFFFF6);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            operand1 = 32'hAAAA_AAAA;
            operand2 = 32'h5555_FFFF;
            control = 2'b10;
            @(posedge clk);
            #1;
            $display("Test Case 005: Bitwise AND (0xAAAAAAAA & 0x5555FFFF)");
            #1;

            check_outputs(32'h0000_AAAA);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            operand1 = 32'h12345678;
            operand2 = 32'h12345678;
            control = 2'b00;
            @(posedge clk);

            reset = 1;
            @(posedge clk);
            #1;
            test_num = 6;
            $display("Test Case 006: Reset Override Check");
            #1;

            check_outputs(32'h00000000);
            reset = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("alu Testbench");
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
        input [31:0] expected_result;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
        $dumpvars(0,clk, control, operand1, operand2, reset, result);
    end

endmodule
