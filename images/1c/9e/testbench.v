`timescale 1ns/1ps

module pipeline_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] instruction_in;
    reg rst;
    wire [4:0] instruction_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_processor dut (
        .clk(clk),
        .instruction_in(instruction_in),
        .rst(rst),
        .instruction_out(instruction_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            instruction_in = 5'b00000;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Single Instruction Propagation...");
            reset_dut();


            instruction_in = 5'b10101;
            @(posedge clk);


            instruction_in = 5'b00000;


            repeat (4) @(posedge clk);

            #1;
            #1;

            check_outputs(5'b10101);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Pipeline Throughput...");
            reset_dut();


            instruction_in = 5'b01001; @(posedge clk);
            instruction_in = 5'b11010; @(posedge clk);
            instruction_in = 5'b00111; @(posedge clk);
            instruction_in = 5'b10111; @(posedge clk);
            instruction_in = 5'b11111; @(posedge clk);


            instruction_in = 5'b00000;
            repeat (4) @(posedge clk);

            #1;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Mid-flow Reset...");
            reset_dut();

            instruction_in = 5'b10101;
            @(posedge clk);
            instruction_in = 5'b11111;
            @(posedge clk);


            rst = 1;
            repeat (2) @(posedge clk);
            rst = 0;


            repeat (5) @(posedge clk);

            #1;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Max Operand Values...");
            reset_dut();

            instruction_in = 5'b11111;
            @(posedge clk);
            instruction_in = 5'b00000;

            repeat (4) @(posedge clk);

            #1;
            #1;

            check_outputs(5'b11111);
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
        input [4:0] expected_instruction_out;
        begin
            if (expected_instruction_out === (expected_instruction_out ^ instruction_out ^ expected_instruction_out)) begin
                $display("PASS");
                $display("  Outputs: instruction_out=%h",
                         instruction_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: instruction_out=%h",
                         expected_instruction_out);
                $display("  Got:      instruction_out=%h",
                         instruction_out);
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
        $dumpvars(0,clk, instruction_in, rst, instruction_out);
    end

endmodule
