`timescale 1ns/1ps

module pipelined_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] input_a;
    reg [4:0] input_b;
    reg [1:0] opcode;
    reg rst;
    wire [4:0] result;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_processor dut (
        .clk(clk),
        .input_a(input_a),
        .input_b(input_b),
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
            input_a = 0;
            input_b = 0;
            opcode = 2'b01;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Addition (5 + 10)", test_num);
            reset_dut();


            input_a = 5'd5;
            input_b = 5'd10;
            opcode = 2'b00;
            @(posedge clk);


            opcode = 2'b01;
            repeat(4) @(posedge clk);


            #1 #1;
 check_outputs(5'd15, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overflow Addition (31 + 1)", test_num);
            reset_dut();

            input_a = 5'd31;
            input_b = 5'd1;
            opcode = 2'b00;
            @(posedge clk);

            opcode = 2'b01;
            repeat(4) @(posedge clk);


            #1 #1;
 check_outputs(5'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: NOP Operation", test_num);
            reset_dut();

            input_a = 5'd10;
            input_b = 5'd10;
            opcode = 2'b01;
            @(posedge clk);

            repeat(4) @(posedge clk);


            #1 #1;
 check_outputs(result, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Addition (0 + 0)", test_num);
            reset_dut();

            input_a = 5'd0;
            input_b = 5'd0;
            opcode = 2'b00;
            @(posedge clk);

            opcode = 2'b01;
            repeat(4) @(posedge clk);

            #1 #1;
 check_outputs(5'd0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Values (15 + 16)", test_num);
            reset_dut();

            input_a = 5'd15;
            input_b = 5'd16;
            opcode = 2'b00;
            @(posedge clk);

            opcode = 2'b01;
            repeat(4) @(posedge clk);

            #1 #1;
 check_outputs(5'd31, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Pipeline throughput (Last of 3 back-to-back adds)", test_num);
            reset_dut();


            input_a = 5'd1; input_b = 5'd1; opcode = 2'b00; @(posedge clk);

            input_a = 5'd2; input_b = 5'd2; opcode = 2'b00; @(posedge clk);

            input_a = 5'd3; input_b = 5'd3; opcode = 2'b00; @(posedge clk);

            opcode = 2'b01;
            repeat(4) @(posedge clk);


            #1 #1;
 check_outputs(5'd6, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipelined_processor Testbench");
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
        input [4:0] expected_result;
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
        $dumpvars(0,clk, input_a, input_b, opcode, rst, result, valid);
    end

endmodule
