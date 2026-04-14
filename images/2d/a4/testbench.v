`timescale 1ns/1ps

module instruction_pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] instruction;
    reg reset;
    wire [3:0] output_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    instruction_pipeline dut (
        .clk(clk),
        .instruction(instruction),
        .reset(reset),
        .output_signal(output_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            instruction = 16'h0000;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Opcode 4'b0000", test_num);
            reset_dut();


            instruction = 16'h0AAA;


            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'b0001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Opcode 4'b0001", test_num);
            reset_dut();


            instruction = 16'h1123;

            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'b0010);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Opcode 4'b0010", test_num);
            reset_dut();


            instruction = 16'h2FFF;

            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'b0011);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Opcode 4'b0011", test_num);
            reset_dut();


            instruction = 16'h3000;

            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'b0100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Opcode 4'b0100 (Default Case)", test_num);
            reset_dut();


            instruction = 16'h4555;

            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Opcode 4'b1111 (Default Case)", test_num);
            reset_dut();


            instruction = 16'hF000;

            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'b0000);
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
        testcase005();
        testcase006();
        
        
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
        input [3:0] expected_output_signal;
        begin
            if (expected_output_signal === (expected_output_signal ^ output_signal ^ expected_output_signal)) begin
                $display("PASS");
                $display("  Outputs: output_signal=%h",
                         output_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_signal=%h",
                         expected_output_signal);
                $display("  Got:      output_signal=%h",
                         output_signal);
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
        $dumpvars(0,clk, instruction, reset, output_signal);
    end

endmodule
