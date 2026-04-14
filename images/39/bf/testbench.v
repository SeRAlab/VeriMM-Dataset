`timescale 1ns/1ps

module instruction_pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] instruction_in;
    reg rst;
    wire decode_enable;
    wire execute_enable;
    wire fetch_enable;
    wire [7:0] instruction_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    instruction_pipeline dut (
        .clk(clk),
        .instruction_in(instruction_in),
        .rst(rst),
        .decode_enable(decode_enable),
        .execute_enable(execute_enable),
        .fetch_enable(fetch_enable),
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
            instruction_in = 8'h00;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Instruction Propagation", test_num);
            reset_dut();

            @(posedge clk);
            instruction_in = 8'hA1;

            @(posedge clk);
            instruction_in = 8'h00;

            @(posedge clk);
            instruction_in = 8'h00;


            #2;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1, 8'hA1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Pipeline Filling", test_num);
            reset_dut();

            @(posedge clk);
            instruction_in = 8'h11;

            @(posedge clk);
            instruction_in = 8'h22;

            @(posedge clk);
            instruction_in = 8'h33;

            #2;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1, 8'h11);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Pipeline Flush", test_num);
            reset_dut();

            @(posedge clk);
            instruction_in = 8'h55;
            @(posedge clk);
            instruction_in = 8'h66;
            @(posedge clk);
            instruction_in = 8'h00;
            @(posedge clk);
            instruction_in = 8'h00;

            #2;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1, 8'h66);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset during operation", test_num);
            reset_dut();

            @(posedge clk);
            instruction_in = 8'hFF;
            @(posedge clk);

            rst = 1;
            #15;
            rst = 0;
            @(posedge clk);

            #2;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Hazard/Stall signal stability", test_num);
            reset_dut();

            @(posedge clk);
            instruction_in = 8'hE0;
            @(posedge clk);
            instruction_in = 8'hE0;
            @(posedge clk);

            #2;


            if (fetch_enable === 1'bx || decode_enable === 1'bx) begin
                $display("FAIL: Enables are X");
                fail_count = fail_count + 1;
            end else begin
                $display("PASS: Pipeline control signals valid");
                pass_count = pass_count + 1;
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
        input expected_decode_enable;
        input expected_execute_enable;
        input expected_fetch_enable;
        input [7:0] expected_instruction_out;
        begin
            if (expected_decode_enable === (expected_decode_enable ^ decode_enable ^ expected_decode_enable) &&
                expected_execute_enable === (expected_execute_enable ^ execute_enable ^ expected_execute_enable) &&
                expected_fetch_enable === (expected_fetch_enable ^ fetch_enable ^ expected_fetch_enable) &&
                expected_instruction_out === (expected_instruction_out ^ instruction_out ^ expected_instruction_out)) begin
                $display("PASS");
                $display("  Outputs: decode_enable=%b, execute_enable=%b, fetch_enable=%b, instruction_out=%h",
                         decode_enable, execute_enable, fetch_enable, instruction_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decode_enable=%b, execute_enable=%b, fetch_enable=%b, instruction_out=%h",
                         expected_decode_enable, expected_execute_enable, expected_fetch_enable, expected_instruction_out);
                $display("  Got:      decode_enable=%b, execute_enable=%b, fetch_enable=%b, instruction_out=%h",
                         decode_enable, execute_enable, fetch_enable, instruction_out);
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
        $dumpvars(0,clk, instruction_in, rst, decode_enable, execute_enable, fetch_enable, instruction_out);
    end

endmodule
