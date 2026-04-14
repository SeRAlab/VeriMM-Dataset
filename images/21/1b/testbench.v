`timescale 1ns/1ps

module instruction_pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg instruction_in;
    wire instruction_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    instruction_pipeline dut (
        .clk(clk),
        .enable(enable),
        .instruction_in(instruction_in),
        .instruction_out(instruction_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 1;
            instruction_in = 0;
            repeat(4) @(posedge clk);
            enable = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Propagating '1' through the pipeline");
            reset_dut();

            enable = 1;
            instruction_in = 1;
            @(posedge clk);

            instruction_in = 0;
            @(posedge clk);
            @(posedge clk);

            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Propagating '0' through the pipeline");
            reset_dut();


            enable = 1;
            instruction_in = 1;
            @(posedge clk);

            instruction_in = 0;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);

            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Testing pipeline stall with enable signal");
            reset_dut();

            enable = 1;
            instruction_in = 1;
            @(posedge clk);

            enable = 0;
            instruction_in = 0;
            repeat(3) @(posedge clk);

            enable = 1;
            @(posedge clk);
            @(posedge clk);

            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Continuous stream of data (1-0-1)");
            reset_dut();

            enable = 1;
            instruction_in = 1; @(posedge clk);
            instruction_in = 0; @(posedge clk);
            instruction_in = 1; @(posedge clk);



            @(posedge clk);
            @(posedge clk);

            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Pipeline should hold value when enable is low");
            reset_dut();


            enable = 1;
            instruction_in = 0;
            repeat(3) @(posedge clk);


            enable = 0;
            instruction_in = 1;
            repeat(5) @(posedge clk);

            #1;
            #1;

            check_outputs(1'b0);
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
        input expected_instruction_out;
        begin
            if (expected_instruction_out === (expected_instruction_out ^ instruction_out ^ expected_instruction_out)) begin
                $display("PASS");
                $display("  Outputs: instruction_out=%b",
                         instruction_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: instruction_out=%b",
                         expected_instruction_out);
                $display("  Got:      instruction_out=%b",
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
        $dumpvars(0,clk, enable, instruction_in, instruction_out);
    end

endmodule
