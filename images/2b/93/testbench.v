`timescale 1ns/1ps

module instruction_pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] instruction_in;
    reg reset;
    wire [31:0] result_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    instruction_pipeline dut (
        .clk(clk),
        .instruction_in(instruction_in),
        .reset(reset),
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
            instruction_in = 32'h0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Basic Execution...");
            reset_dut();


            instruction_in = 32'h01_00_00_0A;
            @(posedge clk); #1;


            instruction_in = 32'h0;
            @(posedge clk); #1;
            @(posedge clk); #1;



            #1;




            check_outputs(32'h0000000A);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Pipeline Throughput...");
            reset_dut();


            instruction_in = 32'h00000001; @(posedge clk); #1;
            instruction_in = 32'h00000002; @(posedge clk); #1;
            instruction_in = 32'h00000003; @(posedge clk); #1;
            instruction_in = 32'h0;        @(posedge clk); #1;


            @(posedge clk); #1;
            #1;

            check_outputs(32'h00000003);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Data Hazard (RAW)...");
            reset_dut();


            instruction_in = 32'hFF_00_00_55;
            @(posedge clk); #1;



            instruction_in = 32'hEE_00_00_01;
            @(posedge clk); #1;

            instruction_in = 32'h0;
            @(posedge clk); #1;
            @(posedge clk); #1;



            #1;




            check_outputs(32'h00000056);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Mid-operation Reset...");
            reset_dut();

            instruction_in = 32'hFFFFFFFF;
            @(posedge clk); #1;
            @(posedge clk); #1;

            reset = 1;
            @(posedge clk); #1;
            reset = 0;

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
        $dumpvars(0,clk, instruction_in, reset, result_out);
    end

endmodule
