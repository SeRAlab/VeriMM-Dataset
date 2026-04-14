`timescale 1ns/1ps

module pipelined_cpu_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] instruction;
    reg reset;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_cpu dut (
        .clk(clk),
        .instruction(instruction),
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
            instruction = NOP;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic ADD (R1 = R2 + R3)");
            reset_dut();

            instruction = encode_inst(OP_ADD, 5'd2, 5'd3, 5'd1);
            @(posedge clk);

            instruction = NOP;
            @(posedge clk);

            @(posedge clk);

            @(posedge clk);

            @(posedge clk);

            #1;


            check_outputs(32'h00000005);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Basic SUB (R4 = R10 - R4)");
            reset_dut();
            instruction = encode_inst(OP_SUB, 5'd10, 5'd4, 5'd4);
            @(posedge clk);
            instruction = NOP;
            repeat(4) @(posedge clk);

            #1;


            check_outputs(32'h00000006);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: AND and OR sequence");
            reset_dut();

            instruction = encode_inst(OP_AND, 5'd7, 5'd3, 5'd5);
            @(posedge clk);

            instruction = encode_inst(OP_OR, 5'd8, 5'd1, 5'd6);
            @(posedge clk);
            instruction = NOP;


            repeat(3) @(posedge clk);

            #1;


            check_outputs(32'h00000003);


            @(posedge clk);
            #1;

            check_outputs(32'h00000009);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Data Hazard - EX to EX Forwarding");
            reset_dut();

            instruction = encode_inst(OP_ADD, 5'd2, 5'd3, 5'd1);
            @(posedge clk);

            instruction = encode_inst(OP_ADD, 5'd1, 5'd2, 5'd4);
            @(posedge clk);
            instruction = NOP;

            repeat(3) @(posedge clk);

            $display("Checking Inst 1 result...");
            #1;

            check_outputs(32'h00000005);

            @(posedge clk);

            $display("Checking Inst 2 result (Forwarded)...");
            #1;

            check_outputs(32'h00000007);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Data Hazard - MEM to EX Forwarding");
            reset_dut();

            instruction = encode_inst(OP_ADD, 5'd10, 5'd2, 5'd1);
            @(posedge clk);
            instruction = NOP;
            @(posedge clk);

            instruction = encode_inst(OP_ADD, 5'd1, 5'd1, 5'd5);
            @(posedge clk);
            instruction = NOP;

            repeat(2) @(posedge clk);

            #1;


            check_outputs(32'h0000000c);
            @(posedge clk);

            @(posedge clk);

            #1;


            check_outputs(32'h00000018);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipelined_cpu Testbench");
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
        $dumpvars(0,clk, instruction, reset, result);
    end

endmodule
