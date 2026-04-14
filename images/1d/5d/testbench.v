`timescale 1ns/1ps

module pipelined_processor_tb;

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
    pipelined_processor dut (
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
        instruction = 32'h0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Single Instruction Propagation", test_num);
        reset_dut();

        instruction = 32'hA5A5A5A5;
        @(posedge clk);
        instruction = 32'h0;


        repeat(4) @(posedge clk);
        #2;

        #1;


        check_outputs(32'hA5A5A5A5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset Behavior Check", test_num);
        reset_dut();


        #2;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Continuous Pipeline Stream", test_num);
        reset_dut();


        instruction = 32'h00000001; @(posedge clk);
        instruction = 32'h00000002; @(posedge clk);
        instruction = 32'h00000003; @(posedge clk);
        instruction = 32'h00000004; @(posedge clk);
        instruction = 32'h00000005; @(posedge clk);



        repeat(4) @(posedge clk);
        #2;

        #1;


        check_outputs(32'h00000005);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Pipeline Latency Check", test_num);
        reset_dut();

        instruction = 32'hFFFFFFFF;
        @(posedge clk);
        instruction = 32'h0;

        repeat(2) @(posedge clk);
        #2;


        if (result !== 32'hFFFFFFFF) begin
            $display("  PASS: Latency confirmed, result not early.");

            repeat(2) @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFFFFFF);
        end else begin
            $display("  FAIL: Result appeared too early! Pipeline stages might be bypassed.");
            fail_count = fail_count + 1;
        end
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
