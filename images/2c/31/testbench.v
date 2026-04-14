`timescale 1ns/1ps

module pipeline_processor_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    reg [1:0] opcode;
    reg rst;
    wire [7:0] result;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_processor dut (
        .A(A),
        .B(B),
        .clk(clk),
        .opcode(opcode),
        .rst(rst),
        .result(result),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            A = 0;
            B = 0;
            opcode = 2'b10;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Addition (15 + 25)", test_num);
            reset_dut();


            A <= 8'd15;
            B <= 8'd25;
            opcode <= 2'b00;

            @(posedge clk);
            opcode <= 2'b10;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd40, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Subtraction (100 - 40)", test_num);
            reset_dut();

            A <= 8'd100;
            B <= 8'd40;
            opcode <= 2'b01;

            @(posedge clk);
            opcode <= 2'b10;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd60, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition Overflow (250 + 10)", test_num);
            reset_dut();

            A <= 8'hFA;
            B <= 8'h0A;
            opcode <= 2'b00;

            @(posedge clk);
            opcode <= 2'b10;

            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h04, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction Underflow (10 - 20)", test_num);
            reset_dut();

            A <= 8'd10;
            B <= 8'd20;
            opcode <= 2'b01;

            @(posedge clk);
            opcode <= 2'b10;

            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hF6, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: NOP Operation", test_num);
            reset_dut();

            A <= 8'hFF;
            B <= 8'hFF;
            opcode <= 2'b10;

            @(posedge clk);
            @(posedge clk);
            #2;

            #1;


            check_outputs(result, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset during operation", test_num);
            reset_dut();

            A <= 8'd50;
            B <= 8'd50;
            opcode <= 2'b00;

            @(posedge clk);
            rst <= 1;
            @(posedge clk);
            #2;


            if (valid === 1'b0) begin
                $display("PASS: Output invalidated by reset");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Valid signal high during/after reset");
                fail_count = fail_count + 1;
            end
            rst <= 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline_processor Testbench");
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
        input [7:0] expected_result;
        input expected_valid;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: result=%h, valid=%b",
                         result, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, valid=%b",
                         expected_result, expected_valid);
                $display("  Got:      result=%h, valid=%b",
                         result, valid);
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
        $dumpvars(0,A, B, clk, opcode, rst, result, valid);
    end

endmodule
