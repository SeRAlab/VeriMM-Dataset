`timescale 1ns/1ps

module pipelined_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] instruction;
    reg reset;
    wire [3:0] reg0_out;
    wire [3:0] reg1_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_processor dut (
        .clk(clk),
        .instruction(instruction),
        .reset(reset),
        .reg0_out(reg0_out),
        .reg1_out(reg1_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting the processor...");
            reset = 1;
            instruction = 4'h0;
            repeat (2) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset State Check", test_num);
            reset_dut();


            repeat (2) @(posedge clk);

            #1;


            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Load Register 0", test_num);
            reset_dut();


            instruction = 4'h1;
            @(posedge clk);


            instruction = 4'h0;
            repeat (5) @(posedge clk);




            #1;





            check_outputs(4'h1, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Load Register 1", test_num);
            reset_dut();

            instruction = 4'h2;
            @(posedge clk);

            instruction = 4'h0;
            repeat (5) @(posedge clk);

            #1;


            check_outputs(4'h0, 4'h1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Pipeline Sequential Load", test_num);
            reset_dut();

            instruction = 4'h1;
            @(posedge clk);
            instruction = 4'h2;
            @(posedge clk);
            instruction = 4'h0;



            repeat (5) @(posedge clk);

            #1;


            check_outputs(4'h1, 4'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Arithmetic Operation", test_num);
            reset_dut();


            instruction = 4'h1; @(posedge clk);
            instruction = 4'h2; @(posedge clk);



            instruction = 4'h0; repeat (3) @(posedge clk);

            instruction = 4'h3;
            @(posedge clk);
            instruction = 4'h0;


            repeat (5) @(posedge clk);


            #1;



            check_outputs(4'h2, 4'h1);
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
        input [3:0] expected_reg0_out;
        input [3:0] expected_reg1_out;
        begin
            if (expected_reg0_out === (expected_reg0_out ^ reg0_out ^ expected_reg0_out) &&
                expected_reg1_out === (expected_reg1_out ^ reg1_out ^ expected_reg1_out)) begin
                $display("PASS");
                $display("  Outputs: reg0_out=%h, reg1_out=%h",
                         reg0_out, reg1_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reg0_out=%h, reg1_out=%h",
                         expected_reg0_out, expected_reg1_out);
                $display("  Got:      reg0_out=%h, reg1_out=%h",
                         reg0_out, reg1_out);
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
        $dumpvars(0,clk, instruction, reset, reg0_out, reg1_out);
    end

endmodule
