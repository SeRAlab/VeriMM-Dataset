`timescale 1ns/1ps

module pipeline_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg [31:0] instruction_in;
    reg reset;
    wire [31:0] instruction_out;
    wire [31:0] result_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_processor dut (
        .clk(clk),
        .data_in(data_in),
        .instruction_in(instruction_in),
        .reset(reset),
        .instruction_out(instruction_out),
        .result_out(result_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            instruction_in = 0;
            data_in = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Instruction Flow", test_num);
            reset_dut();


            instruction_in = 32'hA0000001;
            data_in = 32'h00000000;
            @(posedge clk);


            instruction_in = 32'h0;


            repeat(4) @(posedge clk);


            #1;



            check_outputs(32'hA0000001, 32'h00000001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: EX-to-EX Forwarding Hazard", test_num);
            reset_dut();


            instruction_in = 32'hB000000A;
            @(posedge clk);


            instruction_in = 32'hC0000001;
            @(posedge clk);

            instruction_in = 32'h0;


            repeat(4) @(posedge clk);


            #1;



            check_outputs(32'hC0000001, 32'h0000000B);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: MEM-to-EX Forwarding Hazard", test_num);
            reset_dut();


            instruction_in = 32'hD0000000;
            data_in = 32'hFEEDFACE;
            @(posedge clk);


            instruction_in = 32'h0;
            @(posedge clk);


            instruction_in = 32'hE0000000;
            @(posedge clk);

            instruction_in = 32'h0;


            repeat(4) @(posedge clk);

            #1;


            check_outputs(32'hE0000000, 32'hFEEDFACE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Pipeline Throughput (Full Pipe)", test_num);
            reset_dut();

            instruction_in = 32'h10000000; @(posedge clk);
            instruction_in = 32'h20000000; @(posedge clk);
            instruction_in = 32'h30000000; @(posedge clk);
            instruction_in = 32'h40000000; @(posedge clk);
            instruction_in = 32'h50000000; @(posedge clk);
            instruction_in = 32'h0;


            repeat(4) @(posedge clk);
            #1;

            check_outputs(32'h10000000, 32'h10000000);


            @(posedge clk);
            #1;

            check_outputs(32'h20000000, 32'h20000000);
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
        input [31:0] expected_instruction_out;
        input [31:0] expected_result_out;
        begin
            if (expected_instruction_out === (expected_instruction_out ^ instruction_out ^ expected_instruction_out) &&
                expected_result_out === (expected_result_out ^ result_out ^ expected_result_out)) begin
                $display("PASS");
                $display("  Outputs: instruction_out=%h, result_out=%h",
                         instruction_out, result_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: instruction_out=%h, result_out=%h",
                         expected_instruction_out, expected_result_out);
                $display("  Got:      instruction_out=%h, result_out=%h",
                         instruction_out, result_out);
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
        $dumpvars(0,clk, data_in, instruction_in, reset, instruction_out, result_out);
    end

endmodule
