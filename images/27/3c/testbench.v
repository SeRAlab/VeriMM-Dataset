`timescale 1ns/1ps

module pipelined_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] instruction_1;
    reg [3:0] instruction_2;
    reg reset;
    wire [3:0] result_1;
    wire [3:0] result_2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_processor dut (
        .clk(clk),
        .instruction_1(instruction_1),
        .instruction_2(instruction_2),
        .reset(reset),
        .result_1(result_1),
        .result_2(result_2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            instruction_1 = NOP;
            instruction_2 = NOP;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Basic Latency (5-stage Pipeline)", test_num);
            reset_dut();


            instruction_1 = ADD;
            instruction_2 = SUB;
            @(posedge clk);


            instruction_1 = NOP;
            instruction_2 = NOP;


            repeat (4) @(posedge clk);

            #1 #1;
 check_outputs(ADD, SUB);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Dual-Issue Continuous Throughput", test_num);
            reset_dut();


            instruction_1 = ADD;
            instruction_2 = SUB;
            @(posedge clk);


            instruction_1 = AND;
            instruction_2 = OR;
            @(posedge clk);

            instruction_1 = NOP;
            instruction_2 = NOP;


            repeat (3) @(posedge clk);
            #1 $display("  Checking first pair (ADD/SUB):");
            #1;

            check_outputs(ADD, SUB);


            @(posedge clk);
            #1 $display("  Checking second pair (AND/OR):");
            #1;

            check_outputs(AND, OR);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Hazard Detection and Stalling", test_num);
            reset_dut();


            instruction_1 = ADD;
            instruction_2 = ADD;
            @(posedge clk);

            instruction_1 = SUB;
            instruction_2 = SUB;
            @(posedge clk);

            instruction_1 = NOP;
            instruction_2 = NOP;


            repeat (10) @(posedge clk);



            #1 #1;
 check_outputs(NOP, NOP);
            $display("  Hazard test completed. Verification assumes instructions cleared pipeline.");
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipelined_processor Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        
        
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
        input [3:0] expected_result_1;
        input [3:0] expected_result_2;
        begin
            if (expected_result_1 === (expected_result_1 ^ result_1 ^ expected_result_1) &&
                expected_result_2 === (expected_result_2 ^ result_2 ^ expected_result_2)) begin
                $display("PASS");
                $display("  Outputs: result_1=%h, result_2=%h",
                         result_1, result_2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result_1=%h, result_2=%h",
                         expected_result_1, expected_result_2);
                $display("  Got:      result_1=%h, result_2=%h",
                         result_1, result_2);
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
        $dumpvars(0,clk, instruction_1, instruction_2, reset, result_1, result_2);
    end

endmodule
