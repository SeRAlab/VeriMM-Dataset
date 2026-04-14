`timescale 1ns/1ps

module instruction_pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] instruction_in;
    reg rst;
    wire [31:0] instruction_out;
    wire [31:0] result_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    instruction_pipeline dut (
        .clk(clk),
        .instruction_in(instruction_in),
        .rst(rst),
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
            rst = 1;
            instruction_in = 32'h0;
            @(posedge clk);
            @(posedge clk);
            #1 rst = 0;
            $display("Reset complete.");
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nRunning testcase%03d: Basic 5-stage flow", test_num);
            reset_dut();


            instruction_in = 32'h0000_0001;
            @(posedge clk);
            instruction_in = 32'h0;


            repeat(4) @(posedge clk);
            #2;



            #1;




            check_outputs(32'h0000_0001, 32'h0000_000A);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nRunning testcase%03d: Forwarding EX to EX", test_num);
            reset_dut();


            instruction_in = 32'h0000_0010;
            @(posedge clk);

            instruction_in = 32'h0000_0011;
            @(posedge clk);
            instruction_in = 32'h0;




            repeat(4) @(posedge clk);
            #2;


            #1;



            check_outputs(32'h0000_0011, 32'h0000_0105);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nRunning testcase%03d: Forwarding MEM to EX", test_num);
            reset_dut();

            instruction_in = 32'h0000_0020;
            @(posedge clk);
            instruction_in = 32'h0;
            @(posedge clk);
            instruction_in = 32'h0000_0021;
            @(posedge clk);
            instruction_in = 32'h0;



            repeat(4) @(posedge clk);
            #2;

            #1;


            check_outputs(32'h0000_0021, 32'h0000_0205);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nRunning testcase%03d: Pipeline Full Stress", test_num);
            reset_dut();

            instruction_in = 32'hA000_0001; @(posedge clk);
            instruction_in = 32'hA000_0002; @(posedge clk);
            instruction_in = 32'hA000_0003; @(posedge clk);
            instruction_in = 32'hA000_0004; @(posedge clk);
            instruction_in = 32'hA000_0005; @(posedge clk);
            instruction_in = 32'h0;



            repeat(4) @(posedge clk);
            #2;

            #1;


            check_outputs(32'hA000_0005, 32'h0000_0055);
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
        $dumpvars(0,clk, instruction_in, rst, instruction_out, result_out);
    end

endmodule
