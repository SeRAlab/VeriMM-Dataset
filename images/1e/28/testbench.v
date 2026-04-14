`timescale 1ns/1ps

module pipeline_arithmetic_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] operand1;
    reg [31:0] operand2;
    reg [1:0] operation;
    reg rst_n;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_arithmetic dut (
        .clk(clk),
        .operand1(operand1),
        .operand2(operand2),
        .operation(operation),
        .rst_n(rst_n),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            operand1 = 0;
            operand2 = 0;
            operation = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            @(posedge clk);
            #1;
            operand1 = 32'd100;
            operand2 = 32'd250;
            operation = 2'b00;


            repeat(7) @(posedge clk);
            #2;
            #1;

            check_outputs(32'd350);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(posedge clk);
            #1;
            operand1 = 32'd500;
            operand2 = 32'd150;
            operation = 2'b01;

            repeat(7) @(posedge clk);
            #2;
            #1;

            check_outputs(32'd350);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(posedge clk);
            #1;
            operand1 = 32'd10;
            operand2 = 32'd20;
            operation = 2'b01;

            repeat(7) @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFFFFF6);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            @(posedge clk);
            #1;
            operand1 = 32'hFFFFFFFF;
            operand2 = 32'h00000001;
            operation = 2'b00;

            repeat(7) @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            @(posedge clk);
            #1;
            operand1 = 32'h0;
            operand2 = 32'h0;
            operation = 2'b00;

            repeat(7) @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline_arithmetic Testbench");
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
        $dumpvars(0,clk, operand1, operand2, operation, rst_n, result);
    end

endmodule
