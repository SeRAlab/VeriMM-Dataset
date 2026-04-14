`timescale 1ns/1ps

module calculator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] operand1;
    reg [31:0] operand2;
    reg [1:0] operation;
    reg reset_n;
    wire [31:0] result;

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
        .reset_n(reset_n),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            operand1 = 0;
            operand2 = 0;
            operation = 0;
            #15;
            reset_n = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Addition", test_num);
            reset_dut();
            @(negedge clk);
            operand1 = 32'd150;
            operand2 = 32'd350;
            operation = 2'b00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'd500);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic Subtraction", test_num);
            reset_dut();
            @(negedge clk);
            operand1 = 32'd1000;
            operand2 = 32'd400;
            operation = 2'b01;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'd600);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Subtraction (Negative Result)", test_num);
            reset_dut();
            @(negedge clk);
            operand1 = 32'd10;
            operand2 = 32'd20;
            operation = 2'b01;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hFFFFFFF6);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Basic Multiplication", test_num);
            reset_dut();
            @(negedge clk);
            operand1 = 32'd12;
            operand2 = 32'd12;
            operation = 2'b10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'd144);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Basic Division", test_num);
            reset_dut();
            @(negedge clk);
            operand1 = 32'd100;
            operand2 = 32'd5;
            operation = 2'b11;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'd20);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Integer Division (Truncation)", test_num);
            reset_dut();
            @(negedge clk);
            operand1 = 32'd10;
            operand2 = 32'd3;
            operation = 2'b11;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'd3);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Addition Overflow", test_num);
            reset_dut();
            @(negedge clk);
            operand1 = 32'hFFFFFFFF;
            operand2 = 32'h00000001;
            operation = 2'b00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Multiplication Truncation", test_num);
            reset_dut();
            @(negedge clk);
            operand1 = 32'h00010000;
            operand2 = 32'h00010000;
            operation = 2'b10;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Asynchronous Reset Verification", test_num);
            reset_dut();
            @(negedge clk);
            operand1 = 32'd50;
            operand2 = 32'd50;
            operation = 2'b00;
            @(posedge clk);
            #2;

            reset_n = 0;
            #1;
            #1;

            check_outputs(32'h00000000);
            reset_n = 1;
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
        testcase009();
        
        
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
        $dumpvars(0,clk, operand1, operand2, operation, reset_n, result);
    end

endmodule
