`timescale 1ns/1ps

module instruction_pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] instruction_in;
    reg rst;
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
            $display("DUT Reset Complete");
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Basic Propagation...");
            reset_dut();

            instruction_in = 32'h2001000F;
            @(posedge clk);
            instruction_in = 32'h0;


            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000000F);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Sequential Pipeline Flow...");
            reset_dut();


            instruction_in = 32'h2001000A; @(posedge clk);

            instruction_in = 32'h20020014; @(posedge clk);

            instruction_in = 32'h2003001E; @(posedge clk);
            instruction_in = 32'h0;


            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000001E);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: EX-to-EX Forwarding...");
            reset_dut();


            instruction_in = 32'h20010005; @(posedge clk);


            instruction_in = 32'h00201020; @(posedge clk);
            instruction_in = 32'h0;


            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000005);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Load-to-Use Stall...");
            reset_dut();


            instruction_in = 32'h8C010000; @(posedge clk);

            instruction_in = 32'h00211020; @(posedge clk);
            instruction_in = 32'h0;



            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000014);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Mid-stream Reset...");
            reset_dut();

            instruction_in = 32'h200100FF; @(posedge clk);
            instruction_in = 32'h200200FF; @(posedge clk);


            rst = 1;
            repeat(2) @(posedge clk);
            rst = 0;

            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00000000);
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
        input [31:0] expected_result_out;
        begin
            if (expected_result_out === (expected_result_out ^ result_out ^ expected_result_out)) begin
                $display("PASS");
                $display("  Outputs: result_out=%h",
                         result_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result_out=%h",
                         expected_result_out);
                $display("  Got:      result_out=%h",
                         result_out);
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
        $dumpvars(0,clk, instruction_in, rst, result_out);
    end

endmodule
