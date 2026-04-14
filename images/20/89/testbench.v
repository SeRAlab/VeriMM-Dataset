`timescale 1ns/1ps

module pipeline_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] instruction_in;
    reg reset;
    wire [7:0] output_instruction;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_processor dut (
        .clk(clk),
        .instruction_in(instruction_in),
        .reset(reset),
        .output_instruction(output_instruction)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            instruction_in = 8'h00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Instruction Propagation", test_num);
            reset_dut();


            instruction_in = 8'hA5;
            @(posedge clk);


            instruction_in = 8'h00;
            repeat (6) @(posedge clk);



            #1;




            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Continuous Instruction Stream", test_num);
            reset_dut();


            instruction_in = 8'h11; @(posedge clk);
            instruction_in = 8'h22; @(posedge clk);
            instruction_in = 8'h33; @(posedge clk);
            instruction_in = 8'h44; @(posedge clk);


            instruction_in = 8'h00;




            repeat (6) @(posedge clk);

            #1;


            check_outputs(8'h44);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Mid-Operation", test_num);
            reset_dut();

            instruction_in = 8'hFF;
            repeat (3) @(posedge clk);


            reset = 1;
            @(posedge clk);
            reset = 0;


            repeat (5) @(posedge clk);


            #1;



            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Hazard/Stall Propagation", test_num);
            reset_dut();

            instruction_in = 8'h77;
            @(posedge clk);
            instruction_in = 8'h00;


            repeat (15) @(posedge clk);

            #1;


            check_outputs(8'h77);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline_processor Testbench");
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
        input [7:0] expected_output_instruction;
        begin
            if (expected_output_instruction === (expected_output_instruction ^ output_instruction ^ expected_output_instruction)) begin
                $display("PASS");
                $display("  Outputs: output_instruction=%h",
                         output_instruction);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_instruction=%h",
                         expected_output_instruction);
                $display("  Got:      output_instruction=%h",
                         output_instruction);
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
        $dumpvars(0,clk, instruction_in, reset, output_instruction);
    end

endmodule
