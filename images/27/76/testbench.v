`timescale 1ns/1ps

module pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] instruction_in;
    reg reset;
    wire [4:0] instruction_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline dut (
        .clk(clk),
        .instruction_in(instruction_in),
        .reset(reset),
        .instruction_out(instruction_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            instruction_in = 5'b0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Single Instruction Propagation");
            reset_dut();


            instruction_in = 5'h15;
            @(posedge clk);


            instruction_in = 5'h00;
            repeat(4) @(posedge clk);


            #1 #1;
 check_outputs(5'h15);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Pipeline Sequence (Streaming)");
            reset_dut();

            instruction_in = 5'h01; @(posedge clk);
            instruction_in = 5'h02; @(posedge clk);
            instruction_in = 5'h03; @(posedge clk);
            instruction_in = 5'h04; @(posedge clk);
            instruction_in = 5'h05; @(posedge clk);



            instruction_in = 5'h00;
            repeat(4) @(posedge clk);

            #1 #1;
 check_outputs(5'h05);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Boundary Values (All Ones)");
            reset_dut();

            instruction_in = 5'h1F;
            repeat(5) @(posedge clk);

            #1 #1;
 check_outputs(5'h1F);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Reset during Operation");
            reset_dut();

            instruction_in = 5'h0A;
            repeat(2) @(posedge clk);


            reset = 1;
            @(posedge clk);
            reset = 0;


            repeat(3) @(posedge clk);


            #1 #1;
 check_outputs(5'h00);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Intermittent Data");
            reset_dut();

            instruction_in = 5'h12; @(posedge clk);
            instruction_in = 5'h00; @(posedge clk);
            instruction_in = 5'h00; @(posedge clk);
            instruction_in = 5'h00; @(posedge clk);
            instruction_in = 5'h00; @(posedge clk);

            instruction_in = 5'h0B; @(posedge clk);
            repeat(4) @(posedge clk);

            #1 #1;
 check_outputs(5'h0B);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline Testbench");
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
        $dumpvars(0,clk, instruction_in, reset, instruction_out);
    end

endmodule
