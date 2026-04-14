`timescale 1ns/1ps

module pipeline_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] instruction_in;
    reg rst;
    wire [1:0] result_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_processor dut (
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
            instruction_in = 2'b00;
            @(posedge clk);
            @(posedge clk);
            #1 rst = 0;

            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Instruction 2'b00", test_num);
            reset_dut();

            instruction_in = 2'b00;


            repeat(5) @(posedge clk);

            #1 #1;
 check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Instruction 2'b01", test_num);
            reset_dut();

            instruction_in = 2'b01;
            repeat(5) @(posedge clk);

            #1 #1;
 check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Instruction 2'b10", test_num);
            reset_dut();

            instruction_in = 2'b10;
            repeat(5) @(posedge clk);

            #1 #1;
 check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Instruction 2'b11", test_num);
            reset_dut();

            instruction_in = 2'b11;
            repeat(5) @(posedge clk);

            #1 #1;
 check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Sequential Pipeline Flow", test_num);
            reset_dut();


            instruction_in = 2'b01;
            @(posedge clk);


            instruction_in = 2'b11;
            @(posedge clk);


            instruction_in = 2'b00;




            repeat(4) @(posedge clk);

            #1 #1;
 check_outputs(2'b11);
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
        input [1:0] expected_result_out;
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
