`timescale 1ns/1ps

module pipeline_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] instruction;
    reg reset;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_processor dut (
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
            instruction = 8'h00;
            @(posedge clk);
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Load Immediate...");
            reset_dut();


            instruction = 8'h19;
            @(posedge clk);
            instruction = 8'h00;


            repeat (6) @(posedge clk);

            #1;


            check_outputs(8'h19);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Arithmetic ADDI...");
            reset_dut();


            instruction = 8'h0A;
            @(posedge clk);

            instruction = 8'h45;
            @(posedge clk);
            instruction = 8'h00;


            repeat (7) @(posedge clk);

            #1;


            check_outputs(8'h0F);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Data Forwarding Check...");
            reset_dut();


            instruction = 8'h02;
            @(posedge clk);

            instruction = 8'h42;
            @(posedge clk);

            instruction = 8'h42;
            @(posedge clk);
            instruction = 8'h00;

            repeat (8) @(posedge clk);

            #1;


            check_outputs(8'h06);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Memory Store and Load...");
            reset_dut();


            instruction = 8'h32;
            @(posedge clk);

            instruction = 8'h8F;
            @(posedge clk);

            instruction = 8'h00;
            @(posedge clk);

            instruction = 8'hCF;
            @(posedge clk);
            instruction = 8'h00;

            repeat (10) @(posedge clk);

            #1;


            check_outputs(8'h32);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Reset mid-execution...");
            reset_dut();

            instruction = 8'hFF;
            @(posedge clk);
            @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;

            repeat (5) @(posedge clk);

            #1;


            check_outputs(8'h00);
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
        $dumpvars(0,clk, instruction, reset, result);
    end

endmodule
