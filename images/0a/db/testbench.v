`timescale 1ns/1ps

module instruction_pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] instruction;
    reg reset;
    wire [4:0] decoded_output;
    wire [4:0] exec_output;
    wire [4:0] mem_output;
    wire [4:0] pc_out;
    wire [4:0] write_back_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    instruction_pipeline dut (
        .clk(clk),
        .instruction(instruction),
        .reset(reset),
        .decoded_output(decoded_output),
        .exec_output(exec_output),
        .mem_output(mem_output),
        .pc_out(pc_out),
        .write_back_output(write_back_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            instruction = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            $display("DUT Reset Complete");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Instruction Propagation", test_num);
            reset_dut();


            instruction = 5'h1A;
            @(posedge clk);


            instruction = 5'h00;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);



            #1;




            check_outputs(
                5'h00,
                5'h00,
                5'h00,
                5'h05,
                5'h1A
            );
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Pipeline Full Stream", test_num);
            reset_dut();


            @(posedge clk) instruction = 5'h01;
            @(posedge clk) instruction = 5'h02;
            @(posedge clk) instruction = 5'h03;
            @(posedge clk) instruction = 5'h04;
            @(posedge clk) instruction = 5'h05;


            #1;



            check_outputs(
                5'h04,
                5'h03,
                5'h02,
                5'h05,
                5'h01
            );
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mid-operation Reset", test_num);
            reset_dut();


            @(posedge clk) instruction = 5'h0A;
            @(posedge clk) instruction = 5'h0B;
            @(posedge clk) instruction = 5'h0C;


            reset = 1;
            @(posedge clk);
            reset = 0;


            #1;



            check_outputs(
                5'h00,
                5'h00,
                5'h00,
                5'h00,
                5'h00
            );
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sequential Data Flow Stability", test_num);
            reset_dut();


            repeat(10) begin
                @(posedge clk) instruction = $unsigned(test_num + instruction + 1);
            end



            #1;




            check_outputs(
                decoded_output,
                exec_output,
                mem_output,
                5'h0A,
                write_back_output
            );
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
        input [4:0] expected_decoded_output;
        input [4:0] expected_exec_output;
        input [4:0] expected_mem_output;
        input [4:0] expected_pc_out;
        input [4:0] expected_write_back_output;
        begin
            if (expected_decoded_output === (expected_decoded_output ^ decoded_output ^ expected_decoded_output) &&
                expected_exec_output === (expected_exec_output ^ exec_output ^ expected_exec_output) &&
                expected_mem_output === (expected_mem_output ^ mem_output ^ expected_mem_output) &&
                expected_pc_out === (expected_pc_out ^ pc_out ^ expected_pc_out) &&
                expected_write_back_output === (expected_write_back_output ^ write_back_output ^ expected_write_back_output)) begin
                $display("PASS");
                $display("  Outputs: decoded_output=%h, exec_output=%h, mem_output=%h, pc_out=%h, write_back_output=%h",
                         decoded_output, exec_output, mem_output, pc_out, write_back_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decoded_output=%h, exec_output=%h, mem_output=%h, pc_out=%h, write_back_output=%h",
                         expected_decoded_output, expected_exec_output, expected_mem_output, expected_pc_out, expected_write_back_output);
                $display("  Got:      decoded_output=%h, exec_output=%h, mem_output=%h, pc_out=%h, write_back_output=%h",
                         decoded_output, exec_output, mem_output, pc_out, write_back_output);
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
        $dumpvars(0,clk, instruction, reset, decoded_output, exec_output, mem_output, pc_out, write_back_output);
    end

endmodule
