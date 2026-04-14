`timescale 1ns/1ps

module pipelined_adder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] operand_a;
    reg [7:0] operand_b;
    reg reset;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_adder dut (
        .clk(clk),
        .operand_a(operand_a),
        .operand_b(operand_b),
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
            operand_a = 0;
            operand_b = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Addition (10 + 20)", test_num);
            reset_dut();
            operand_a = 8'd10;
            operand_b = 8'd20;
            @(posedge clk);


            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Zero Addition (0 + 0)", test_num);
            reset_dut();
            operand_a = 8'h00;
            operand_b = 8'h00;
            @(posedge clk);
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Overflow Handling (255 + 1)", test_num);
            reset_dut();
            operand_a = 8'd255;
            operand_b = 8'd1;
            @(posedge clk);
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Boundary Addition (127 + 128)", test_num);
            reset_dut();
            operand_a = 8'd127;
            operand_b = 8'd128;
            @(posedge clk);
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Pipelined Throughput (Sequence)", test_num);
            reset_dut();


            operand_a = 8'd1; operand_b = 8'd1; @(posedge clk);

            operand_a = 8'd2; operand_b = 8'd2; @(posedge clk);

            operand_a = 8'd3; operand_b = 8'd3; @(posedge clk);

            operand_a = 8'd4; operand_b = 8'd4; @(posedge clk);

            operand_a = 8'd5; operand_b = 8'd5; @(posedge clk);




            repeat(4) @(posedge clk);

            #1;
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Hex value check (0xAA + 0x55)", test_num);
            reset_dut();
            operand_a = 8'hAA;
            operand_b = 8'h55;
            @(posedge clk);
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipelined_adder Testbench");
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
        $dumpvars(0,clk, operand_a, operand_b, reset, result);
    end

endmodule
