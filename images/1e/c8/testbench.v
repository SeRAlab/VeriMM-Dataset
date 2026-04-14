`timescale 1ns/1ps

module pipelined_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] instruction;
    wire [4:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_processor dut (
        .clk(clk),
        .instruction(instruction),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            instruction = {OP_NOP, 3'b000};




            repeat(10) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Basic Addition (ADD 5)", test_num);
            reset_dut();


            instruction = {OP_ADD, 3'd5};
            @(posedge clk);


            instruction = {OP_NOP, 3'd0};


            repeat(7) @(posedge clk);
            #1;

            check_outputs(5'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Consecutive Additions (ADD 2 + ADD 3)", test_num);
            reset_dut();

            instruction = {OP_ADD, 3'd2};
            @(posedge clk);
            instruction = {OP_ADD, 3'd3};
            @(posedge clk);
            instruction = {OP_NOP, 3'd0};



            repeat(7) @(posedge clk);
            #1;

            check_outputs(5'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: NOP Persistence Check", test_num);
            reset_dut();

            instruction = {OP_ADD, 3'd4};
            @(posedge clk);
            instruction = {OP_NOP, 3'd0};

            repeat(7) @(posedge clk);
            $display("Checking initial ADD result...");
            if (result == 5'd4) begin

                repeat(5) @(posedge clk);
                $display("Checking if NOP preserved the value...");
                #1;

                check_outputs(5'd4);
            end else begin
                #1;

                check_outputs(5'd4);
            end
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: 5-bit Overflow (7+7+7+7+7=35 -> 3)", test_num);
            reset_dut();

            repeat(5) begin
                instruction = {OP_ADD, 3'd7};
                @(posedge clk);
            end
            instruction = {OP_NOP, 3'd0};

            repeat(7) @(posedge clk);
            #1;

            check_outputs(5'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Interleaved NOPs (ADD 1, NOP, ADD 6)", test_num);
            reset_dut();

            instruction = {OP_ADD, 3'd1};
            @(posedge clk);
            instruction = {OP_NOP, 3'd7};
            @(posedge clk);
            instruction = {OP_ADD, 3'd6};
            @(posedge clk);
            instruction = {OP_NOP, 3'd0};

            repeat(10) @(posedge clk);
            #1;

            check_outputs(5'd7);
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
        $dumpvars(0,clk, instruction, result);
    end

endmodule
