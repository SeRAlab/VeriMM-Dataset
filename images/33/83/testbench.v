`timescale 1ns/1ps

module pipelined_cpu_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] instruction_in;
    reg reset;
    wire [7:0] reg_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_cpu dut (
        .clk(clk),
        .instruction_in(instruction_in),
        .reset(reset),
        .reg_out(reg_out)
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
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Addition Instruction", test_num);
            reset_dut();


            instruction_in = 8'h40;
            @(posedge clk);
            #1;
            instruction_in = 8'h00;


            repeat (5) @(posedge clk);
            #1;



            #1;




            check_outputs(8'h20);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Independent Instructions Pipeline", test_num);
            reset_dut();

            instruction_in = 8'h40;
            @(posedge clk);
            #1;
            instruction_in = 8'h80;
            @(posedge clk);
            #1;
            instruction_in = 8'hC0;
            @(posedge clk);
            #1;
            instruction_in = 8'h00;


            repeat (6) @(posedge clk);
            #1;


            #1;



            check_outputs(8'h30);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Hazard with Stall", test_num);
            reset_dut();


            instruction_in = 8'h40;
            @(posedge clk);
            #1;


            instruction_in = 8'h84;
            @(posedge clk);
            #1;
            instruction_in = 8'h00;




            repeat (10) @(posedge clk);
            #1;

            #1;


            check_outputs(8'h25);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset during execution", test_num);
            reset_dut();

            instruction_in = 8'h40;
            @(posedge clk);
            @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;
            repeat (5) @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipelined_cpu Testbench");
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
        input [7:0] expected_reg_out;
        begin
            if (expected_reg_out === (expected_reg_out ^ reg_out ^ expected_reg_out)) begin
                $display("PASS");
                $display("  Outputs: reg_out=%h",
                         reg_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reg_out=%h",
                         expected_reg_out);
                $display("  Got:      reg_out=%h",
                         reg_out);
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
        $dumpvars(0,clk, instruction_in, reset, reg_out);
    end

endmodule
