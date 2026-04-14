`timescale 1ns/1ps

module pipeline_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] opcode;
    reg [7:0] operand_a;
    reg [7:0] operand_b;
    reg rst;
    wire [7:0] result;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_processor dut (
        .clk(clk),
        .opcode(opcode),
        .operand_a(operand_a),
        .operand_b(operand_b),
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
            opcode = 0;
            operand_a = 0;
            operand_b = 0;
            repeat(5) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nRunning Testcase001: Basic Addition (15 + 10)");
            reset_dut();


            opcode = 2'b01;
            operand_a = 8'd15;
            operand_b = 8'd10;
            @(posedge clk);


            opcode = 2'b00;
            operand_a = 0;
            operand_b = 0;


            wait(valid === 1);
            #1;
            #1;

            check_outputs(8'd25, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nRunning Testcase002: Basic Subtraction (50 - 20)");
            reset_dut();

            opcode = 2'b10;
            operand_a = 8'd50;
            operand_b = 8'd20;
            @(posedge clk);

            opcode = 2'b00;

            wait(valid === 1);
            #1;
            #1;

            check_outputs(8'd30, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nRunning Testcase003: Addition with Overflow (250 + 10)");
            reset_dut();

            opcode = 2'b01;
            operand_a = 8'd250;
            operand_b = 8'd10;
            @(posedge clk);

            opcode = 2'b00;

            wait(valid === 1);
            #1;
            #1;

            check_outputs(8'd4, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nRunning Testcase004: Subtraction with Underflow (5 - 10)");
            reset_dut();

            opcode = 2'b10;
            operand_a = 8'd5;
            operand_b = 8'd10;
            @(posedge clk);

            opcode = 2'b00;

            wait(valid === 1);
            #1;
            #1;

            check_outputs(8'hFB, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nRunning Testcase005: Zero Result (42 - 42)");
            reset_dut();

            opcode = 2'b10;
            operand_a = 8'd42;
            operand_b = 8'd42;
            @(posedge clk);

            opcode = 2'b00;

            wait(valid === 1);
            #1;
            #1;

            check_outputs(8'd0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nRunning Testcase006: Pipeline Stream (Final check)");
            reset_dut();


            opcode = 2'b01; operand_a = 8'd1; operand_b = 8'd1;
            @(posedge clk);

            opcode = 2'b01; operand_a = 8'd2; operand_b = 8'd2;
            @(posedge clk);

            opcode = 2'b10; operand_a = 8'd10; operand_b = 8'd3;
            @(posedge clk);

            opcode = 2'b00;




            repeat(5) begin
                @(posedge clk);
                if (valid && result == 8'd7) begin

                end
            end
            #1;
            #1;

            check_outputs(8'd7, 1'b1);
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
        $dumpvars(0,clk, opcode, operand_a, operand_b, rst, result, valid);
    end

endmodule
