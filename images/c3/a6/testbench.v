`timescale 1ns/1ps

module calculator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] operand1;
    reg [7:0] operand2;
    reg [1:0] operation;
    reg reset;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    calculator dut (
        .clk(clk),
        .operand1(operand1),
        .operand2(operand2),
        .operation(operation),
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
            operation = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Addition (10 + 20)", test_num);
            reset_dut();
            operand1 = 8'd10;
            operand2 = 8'd20;
            operation = 2'b00;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Subtraction (50 - 20)", test_num);
            reset_dut();
            operand1 = 8'd50;
            operand2 = 8'd20;
            operation = 2'b01;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd30);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition with Overflow (250 + 10)", test_num);
            reset_dut();
            operand1 = 8'd250;
            operand2 = 8'd10;
            operation = 2'b00;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction with Underflow (5 - 10)", test_num);
            reset_dut();
            operand1 = 8'd5;
            operand2 = 8'd10;
            operation = 2'b01;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd251);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition of Zero (127 + 0)", test_num);
            reset_dut();
            operand1 = 8'd127;
            operand2 = 8'd0;
            operation = 2'b00;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd127);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction to Zero (100 - 100)", test_num);
            reset_dut();
            operand1 = 8'd100;
            operand2 = 8'd100;
            operation = 2'b01;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max Value Addition (255 + 255)", test_num);
            reset_dut();
            operand1 = 8'hFF;
            operand2 = 8'hFF;
            operation = 2'b00;
            @(posedge clk);
            #1 #1;
 check_outputs(8'hFE);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify Reset Clears Output", test_num);

            reset_dut();
            operand1 = 8'd50;
            operand2 = 8'd50;
            operation = 2'b00;
            @(posedge clk);
            #1;


            reset = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd0);
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
        $display("calculator Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [7:0] expected_result;
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
        $dumpvars(0,clk, operand1, operand2, operation, reset, result);
    end

endmodule
