`timescale 1ns/1ps

module instruction_pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] instruction_in;
    reg reset;
    wire [31:0] final_result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    instruction_pipeline dut (
        .clk(clk),
        .instruction_in(instruction_in),
        .reset(reset),
        .final_result(final_result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        instruction_in = 32'h0;
        repeat(2) @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Testcase 001: Basic Arithmetic (Single Instruction)");


        instruction_in = 32'h2001000F;
        @(posedge clk);


        instruction_in = 32'h0;
        repeat(5) @(posedge clk);

        #1;


        check_outputs(32'h0000000F);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        $display("Testcase 002: Data Hazard (RAW)");



        instruction_in = 32'h2001000A; @(posedge clk);
        instruction_in = 32'h20220005; @(posedge clk);

        instruction_in = 32'h0;
        repeat(6) @(posedge clk);

        #1;


        check_outputs(32'h0000000F);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        $display("Testcase 003: Load-Use Hazard Stall");



        instruction_in = 32'h8C410000; @(posedge clk);
        instruction_in = 32'h00211820; @(posedge clk);

        instruction_in = 32'h0;
        repeat(7) @(posedge clk);


        #1;



        check_outputs(32'h000000C8);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        $display("Testcase 004: Control Hazard (Branch Flushing)");




        instruction_in = 32'h10000002; @(posedge clk);
        instruction_in = 32'h20010032; @(posedge clk);
        instruction_in = 32'h0;        @(posedge clk);
        instruction_in = 32'h20010064; @(posedge clk);

        repeat(6) @(posedge clk);


        #1;



        check_outputs(32'h00000064);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        $display("Testcase 005: Full Pipeline Throughput");

        instruction_in = 32'h20010001; @(posedge clk);
        instruction_in = 32'h20020002; @(posedge clk);
        instruction_in = 32'h20030003; @(posedge clk);
        instruction_in = 32'h20040004; @(posedge clk);
        instruction_in = 32'h00012820; @(posedge clk);

        instruction_in = 32'h0;
        repeat(6) @(posedge clk);

        #1;


        check_outputs(32'h00000003);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("instruction_pipeline Testbench");
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
        input [31:0] expected_final_result;
        begin
            if (expected_final_result === (expected_final_result ^ final_result ^ expected_final_result)) begin
                $display("PASS");
                $display("  Outputs: final_result=%h",
                         final_result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: final_result=%h",
                         expected_final_result);
                $display("  Got:      final_result=%h",
                         final_result);
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
        $dumpvars(0,clk, instruction_in, reset, final_result);
    end

endmodule
