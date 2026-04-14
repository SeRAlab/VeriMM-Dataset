`timescale 1ns/1ps

module pipeline_risc_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] instruction;
    reg rst;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_risc dut (
        .clk(clk),
        .instruction(instruction),
        .rst(rst),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            instruction = 32'h0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
            $display("System Reset Complete.");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simple ADD Instruction", test_num);
            reset_dut();



            instruction = 32'h00221820;


            repeat (5) @(posedge clk);




            #1 #1;
 check_outputs(32'h00221820);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Logical OR Instruction", test_num);
            reset_dut();


            instruction = 32'h00242825;

            repeat (5) @(posedge clk);

            #1 #1;
 check_outputs(32'h00242825);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Immediate ADDI Instruction", test_num);
            reset_dut();


            instruction = 32'h20010064;

            repeat (5) @(posedge clk);

            #1 #1;
 check_outputs(32'h20010064);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: NOP Propagation", test_num);
            reset_dut();


            instruction = 32'h00000000;

            repeat (5) @(posedge clk);

            #1 #1;
 check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Pipeline Flow (Multiple Instructions)", test_num);
            reset_dut();


            instruction = 32'hA0A0A0A0; @(posedge clk);
            instruction = 32'hB0B0B0B0; @(posedge clk);
            instruction = 32'hC0C0C0C0; @(posedge clk);
            instruction = 32'hD0D0D0D0; @(posedge clk);
            instruction = 32'hE0E0E0E0; @(posedge clk);




            repeat (4) @(posedge clk);

            #1 #1;
 check_outputs(32'hE0E0E0E0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline_risc Testbench");
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
        input [31:0] expected_result;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
        $dumpvars(0,clk, instruction, rst, result);
    end

endmodule
