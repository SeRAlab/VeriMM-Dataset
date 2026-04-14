`timescale 1ns/1ps

module pipelined_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] instruction_in;
    reg reset;
    wire [15:0] instruction_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_processor dut (
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
            instruction_in = 16'h0000;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single Instruction Propagation", test_num);
            reset_dut();

            instruction_in = 16'hABCD;
            @(posedge clk);
            instruction_in = 16'h0000;

            repeat (4) @(posedge clk);

            #1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Constant Instruction Stream", test_num);
            reset_dut();


            instruction_in = 16'h1111; @(posedge clk);
            instruction_in = 16'h2222; @(posedge clk);
            instruction_in = 16'h3333; @(posedge clk);
            instruction_in = 16'h4444; @(posedge clk);
            instruction_in = 16'h5555; @(posedge clk);




            #1;
            #1;

            check_outputs(16'h1111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Checking Pipeline Tail", test_num);
            reset_dut();

            instruction_in = 16'h1111; @(posedge clk);
            instruction_in = 16'h2222; @(posedge clk);
            instruction_in = 16'h3333; @(posedge clk);
            instruction_in = 16'h4444; @(posedge clk);
            instruction_in = 16'h5555; @(posedge clk);

            instruction_in = 16'h0000;
            repeat(4) @(posedge clk);

            #1;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All Zeros Pattern", test_num);
            reset_dut();

            instruction_in = 16'h0000;
            repeat(5) @(posedge clk);

            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All Ones Pattern", test_num);
            reset_dut();

            instruction_in = 16'hFFFF;
            repeat(5) @(posedge clk);

            #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset Recovery", test_num);
            reset_dut();

            instruction_in = 16'hBEEF;
            repeat(3) @(posedge clk);

            reset = 1;
            @(posedge clk);
            reset = 0;
            instruction_in = 16'hCAFE;

            repeat(5) @(posedge clk);

            #1;
            #1;

            check_outputs(16'hCAFE);
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
        input [15:0] expected_instruction_out;
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
