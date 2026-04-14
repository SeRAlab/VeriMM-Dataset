`timescale 1ns/1ps

module instruction_pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] instruction_in;
    reg reset;
    wire decode_valid;
    wire [15:0] decoded_instruction;
    wire execute_valid;
    wire [15:0] executed_result;
    wire fetch_valid;
    wire [15:0] fetched_instruction;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    instruction_pipeline dut (
        .clk(clk),
        .instruction_in(instruction_in),
        .reset(reset),
        .decode_valid(decode_valid),
        .decoded_instruction(decoded_instruction),
        .execute_valid(execute_valid),
        .executed_result(executed_result),
        .fetch_valid(fetch_valid),
        .fetched_instruction(fetched_instruction)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            instruction_in = 16'h0000;
            @(posedge clk);
            #1;
            reset = 0;
            $display("Reset completed.");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Instruction Propagation", test_num);
            reset_dut();


            instruction_in = 16'hA1A1;
            @(posedge clk);
            #1;


            instruction_in = 16'h0000;
            @(posedge clk);
            #1;


            @(posedge clk);
            #1;





            #1;






            check_outputs(
                1'b0, 16'h0000,
                1'b1, 16'hA1A1,
                1'b0, 16'h0000
            );
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Pipeline Full (Three Instructions)", test_num);
            reset_dut();


            instruction_in = 16'h1111;
            @(posedge clk);
            #1;


            instruction_in = 16'h2222;
            @(posedge clk);
            #1;


            instruction_in = 16'h3333;
            @(posedge clk);
            #1;





            #1;






            check_outputs(
                1'b1, 16'h2222,
                1'b1, 16'h1111,
                1'b1, 16'h3333
            );
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Pipeline Reset Behavior", test_num);
            reset_dut();


            instruction_in = 16'hFFFF;
            @(posedge clk);
            #1;
            instruction_in = 16'hEEEE;
            @(posedge clk);
            #1;


            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(
                1'b0, 16'h0000,
                1'b0, 16'h0000,
                1'b0, 16'h0000
            );
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Pipeline Drain", test_num);
            reset_dut();


            instruction_in = 16'h1001; @(posedge clk); #1;
            instruction_in = 16'h2002; @(posedge clk); #1;
            instruction_in = 16'h3003; @(posedge clk); #1;


            instruction_in = 16'h0000; @(posedge clk); #1;
            instruction_in = 16'h0000; @(posedge clk); #1;


            #1;



            check_outputs(
                1'b0, 16'h0000,
                1'b1, 16'h3003,
                1'b0, 16'h0000
            );
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
        input expected_decode_valid;
        input [15:0] expected_decoded_instruction;
        input expected_execute_valid;
        input [15:0] expected_executed_result;
        input expected_fetch_valid;
        input [15:0] expected_fetched_instruction;
        begin
            if (expected_decode_valid === (expected_decode_valid ^ decode_valid ^ expected_decode_valid) &&
                expected_decoded_instruction === (expected_decoded_instruction ^ decoded_instruction ^ expected_decoded_instruction) &&
                expected_execute_valid === (expected_execute_valid ^ execute_valid ^ expected_execute_valid) &&
                expected_executed_result === (expected_executed_result ^ executed_result ^ expected_executed_result) &&
                expected_fetch_valid === (expected_fetch_valid ^ fetch_valid ^ expected_fetch_valid) &&
                expected_fetched_instruction === (expected_fetched_instruction ^ fetched_instruction ^ expected_fetched_instruction)) begin
                $display("PASS");
                $display("  Outputs: decode_valid=%b, decoded_instruction=%h, execute_valid=%b, executed_result=%h, fetch_valid=%b, fetched_instruction=%h",
                         decode_valid, decoded_instruction, execute_valid, executed_result, fetch_valid, fetched_instruction);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decode_valid=%b, decoded_instruction=%h, execute_valid=%b, executed_result=%h, fetch_valid=%b, fetched_instruction=%h",
                         expected_decode_valid, expected_decoded_instruction, expected_execute_valid, expected_executed_result, expected_fetch_valid, expected_fetched_instruction);
                $display("  Got:      decode_valid=%b, decoded_instruction=%h, execute_valid=%b, executed_result=%h, fetch_valid=%b, fetched_instruction=%h",
                         decode_valid, decoded_instruction, execute_valid, executed_result, fetch_valid, fetched_instruction);
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
        $dumpvars(0,clk, instruction_in, reset, decode_valid, decoded_instruction, execute_valid, executed_result, fetch_valid, fetched_instruction);
    end

endmodule
