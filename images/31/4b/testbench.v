`timescale 1ns/1ps

module instruction_pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] instruction_in;
    reg rst;
    wire [7:0] decoded_instruction;
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
        .decoded_instruction(decoded_instruction),
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
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Reset Verification", test_num);
            reset_dut();

            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Single Instruction Propagation (0xAA)", test_num);
            reset_dut();


            instruction_in = 8'hAA;
            @(posedge clk);


            instruction_in = 8'h00;
            @(posedge clk);




            @(posedge clk);
            #1;


            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Pipeline Filling Sequence", test_num);
            reset_dut();


            instruction_in = 8'h11; @(posedge clk);
            instruction_in = 8'h22; @(posedge clk);
            instruction_in = 8'h33; @(posedge clk);
            instruction_in = 8'h44; @(posedge clk);
            instruction_in = 8'h55; @(posedge clk);
            instruction_in = 8'h00;







            #1;
            #1;

            check_outputs(8'h33, 8'h11);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Pipeline Drain Check", test_num);
            reset_dut();

            instruction_in = 8'hA1; @(posedge clk);
            instruction_in = 8'hB2; @(posedge clk);
            instruction_in = 8'h00;


            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 8'hB2);
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
        input [7:0] expected_decoded_instruction;
        input [7:0] expected_instruction_out;
        begin
            if (expected_decoded_instruction === (expected_decoded_instruction ^ decoded_instruction ^ expected_decoded_instruction) &&
                expected_instruction_out === (expected_instruction_out ^ instruction_out ^ expected_instruction_out)) begin
                $display("PASS");
                $display("  Outputs: decoded_instruction=%h, instruction_out=%h",
                         decoded_instruction, instruction_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decoded_instruction=%h, instruction_out=%h",
                         expected_decoded_instruction, expected_instruction_out);
                $display("  Got:      decoded_instruction=%h, instruction_out=%h",
                         decoded_instruction, instruction_out);
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
        $dumpvars(0,clk, instruction_in, rst, decoded_instruction, instruction_out);
    end

endmodule
