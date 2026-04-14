`timescale 1ns/1ps

module pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] instruction_in;
    reg reset;
    wire [31:0] instruction_out;

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
            instruction_in = 32'h0;
            @(posedge clk);
            #1 reset = 0;

            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Single Instruction Latency Check", test_num);
            reset_dut();

            instruction_in = 32'hABCD_1234;
            @(posedge clk);
            instruction_in = 32'h0;


            repeat(4) @(posedge clk);

            #1;
            #1;

            check_outputs(32'hABCD_1234);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Continuous Stream First Instruction Check", test_num);
            reset_dut();

            instruction_in = 32'h1111_1111; @(posedge clk);
            instruction_in = 32'h2222_2222; @(posedge clk);
            instruction_in = 32'h3333_3333; @(posedge clk);
            instruction_in = 32'h4444_4444; @(posedge clk);
            instruction_in = 32'h5555_5555; @(posedge clk);


            #1;
            #1;

            check_outputs(32'h1111_1111);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Reset and Initial Output Check", test_num);
            reset_dut();


            #1;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Stream Drain Check", test_num);
            reset_dut();

            instruction_in = 32'hA1A1_A1A1; @(posedge clk);
            instruction_in = 32'hB2B2_B2B2; @(posedge clk);
            instruction_in = 32'hC3C3_C3C3; @(posedge clk);
            instruction_in = 32'hD4D4_D4D4; @(posedge clk);
            instruction_in = 32'hE5E5_E5E5; @(posedge clk);
            instruction_in = 32'h0;         @(posedge clk);


            repeat(4) @(posedge clk);

            #1;
            #1;

            check_outputs(32'hE5E5_E5E5);
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
