`timescale 1ns/1ps

module instruction_pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] instruction;
    reg rst;
    wire [7:0] decoded_instruction;
    wire [7:0] executed_instruction;
    wire [7:0] fetched_instruction;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    instruction_pipeline dut (
        .clk(clk),
        .instruction(instruction),
        .rst(rst),
        .decoded_instruction(decoded_instruction),
        .executed_instruction(executed_instruction),
        .fetched_instruction(fetched_instruction),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            instruction = 8'h00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Instruction Flow", test_num);
            reset_dut();


            instruction = 8'hAA;
            @(posedge clk);


            instruction = 8'h00;
            @(posedge clk);


            @(posedge clk);

            #1;

            #1;


            check_outputs(8'h00, 8'hAA, 8'h00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pipeline Filling", test_num);
            reset_dut();


            instruction = 8'h11;
            @(posedge clk);


            instruction = 8'h22;
            @(posedge clk);


            instruction = 8'h33;
            @(posedge clk);

            #1;

            #1;


            check_outputs(8'h22, 8'h11, 8'h33, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Mid-Operation", test_num);
            reset_dut();


            instruction = 8'hA1;
            @(posedge clk);
            instruction = 8'hB2;
            @(posedge clk);


            rst = 1;
            @(posedge clk);
            #1 rst = 0;

            #1;

            #1;


            check_outputs(8'h00, 8'h00, 8'h00, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Emptying the Pipeline", test_num);
            reset_dut();


            instruction = 8'hD1; @(posedge clk);
            instruction = 8'hD2; @(posedge clk);
            instruction = 8'hD3; @(posedge clk);


            instruction = 8'h00; @(posedge clk);
            instruction = 8'h00; @(posedge clk);

            #1;

            #1;


            check_outputs(8'h00, 8'hD3, 8'h00, 1'b1);
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
        input [7:0] expected_executed_instruction;
        input [7:0] expected_fetched_instruction;
        input expected_valid;
        begin
            if (expected_decoded_instruction === (expected_decoded_instruction ^ decoded_instruction ^ expected_decoded_instruction) &&
                expected_executed_instruction === (expected_executed_instruction ^ executed_instruction ^ expected_executed_instruction) &&
                expected_fetched_instruction === (expected_fetched_instruction ^ fetched_instruction ^ expected_fetched_instruction) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: decoded_instruction=%h, executed_instruction=%h, fetched_instruction=%h, valid=%b",
                         decoded_instruction, executed_instruction, fetched_instruction, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decoded_instruction=%h, executed_instruction=%h, fetched_instruction=%h, valid=%b",
                         expected_decoded_instruction, expected_executed_instruction, expected_fetched_instruction, expected_valid);
                $display("  Got:      decoded_instruction=%h, executed_instruction=%h, fetched_instruction=%h, valid=%b",
                         decoded_instruction, executed_instruction, fetched_instruction, valid);
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
        $dumpvars(0,clk, instruction, rst, decoded_instruction, executed_instruction, fetched_instruction, valid);
    end

endmodule
