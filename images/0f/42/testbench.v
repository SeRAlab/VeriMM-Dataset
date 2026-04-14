`timescale 1ns/1ps

module instruction_pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] instruction_in;
    reg reset;
    wire [31:0] decode_out;
    wire [31:0] execute_out;
    wire [31:0] fetch_out;
    wire [31:0] memory_out;
    wire [31:0] write_back_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    instruction_pipeline dut (
        .clk(clk),
        .instruction_in(instruction_in),
        .reset(reset),
        .decode_out(decode_out),
        .execute_out(execute_out),
        .fetch_out(fetch_out),
        .memory_out(memory_out),
        .write_back_out(write_back_out)
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
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Standard Sequential Flow");
            reset_dut();


            instruction_in = 32'hAAAAAAAA;
            @(posedge clk);


            instruction_in = 32'hBBBBBBBB;
            @(posedge clk);


            instruction_in = 32'hCCCCCCCC;
            @(posedge clk);


            instruction_in = 32'hDDDDDDDD;
            @(posedge clk);


            instruction_in = 32'hEEEEEEEE;
            @(posedge clk);

            #1;

            #1;


            check_outputs(32'hDDDDDDDD, 32'hCCCCCCCC, 32'hEEEEEEEE, 32'hBBBBBBBB, 32'hAAAAAAAA);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Single Instruction Propagation");
            reset_dut();


            instruction_in = 32'h12345678;
            @(posedge clk);


            instruction_in = 32'h0;
            repeat(4) @(posedge clk);

            #1;

            #1;


            check_outputs(32'h0, 32'h0, 32'h0, 32'h0, 32'h12345678);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Pipeline Clearing");
            reset_dut();


            instruction_in = 32'hF0F0F0F0;
            repeat(5) @(posedge clk);


            instruction_in = 32'h0;
            repeat(5) @(posedge clk);

            #1;

            #1;


            check_outputs(32'h0, 32'h0, 32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Alternating Patterns");
            reset_dut();

            instruction_in = 32'h11111111; @(posedge clk);
            instruction_in = 32'h00000000; @(posedge clk);
            instruction_in = 32'h22222222; @(posedge clk);
            instruction_in = 32'h00000000; @(posedge clk);
            instruction_in = 32'h33333333; @(posedge clk);

            #1;

            #1;


            check_outputs(32'h0, 32'h22222222, 32'h33333333, 32'h0, 32'h11111111);
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
        input [31:0] expected_decode_out;
        input [31:0] expected_execute_out;
        input [31:0] expected_fetch_out;
        input [31:0] expected_memory_out;
        input [31:0] expected_write_back_out;
        begin
            if (expected_decode_out === (expected_decode_out ^ decode_out ^ expected_decode_out) &&
                expected_execute_out === (expected_execute_out ^ execute_out ^ expected_execute_out) &&
                expected_fetch_out === (expected_fetch_out ^ fetch_out ^ expected_fetch_out) &&
                expected_memory_out === (expected_memory_out ^ memory_out ^ expected_memory_out) &&
                expected_write_back_out === (expected_write_back_out ^ write_back_out ^ expected_write_back_out)) begin
                $display("PASS");
                $display("  Outputs: decode_out=%h, execute_out=%h, fetch_out=%h, memory_out=%h, write_back_out=%h",
                         decode_out, execute_out, fetch_out, memory_out, write_back_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decode_out=%h, execute_out=%h, fetch_out=%h, memory_out=%h, write_back_out=%h",
                         expected_decode_out, expected_execute_out, expected_fetch_out, expected_memory_out, expected_write_back_out);
                $display("  Got:      decode_out=%h, execute_out=%h, fetch_out=%h, memory_out=%h, write_back_out=%h",
                         decode_out, execute_out, fetch_out, memory_out, write_back_out);
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
        $dumpvars(0,clk, instruction_in, reset, decode_out, execute_out, fetch_out, memory_out, write_back_out);
    end

endmodule
