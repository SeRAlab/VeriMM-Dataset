`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg IF_flush;
    reg [12:0] PC_plus_4_in;
    reg clk;
    reg hold;
    reg [31:0] instruc_in;
    wire [12:0] PC_plus_4_out;
    wire [31:0] instruc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IF_flush(IF_flush),
        .PC_plus_4_in(PC_plus_4_in),
        .clk(clk),
        .hold(hold),
        .instruc_in(instruc_in),
        .PC_plus_4_out(PC_plus_4_out),
        .instruc_out(instruc_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            IF_flush = 0;
            hold = 0;
            PC_plus_4_in = 0;
            instruc_in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Normal Operation", test_num);

            PC_plus_4_in = 13'h0ABC;
            instruc_in = 32'hDEADBEEF;
            hold = 0;
            IF_flush = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(13'h0ABC, 32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Hold Functionality", test_num);


            PC_plus_4_in = 13'h0100;
            instruc_in = 32'h11112222;
            @(posedge clk);
            #1;


            hold = 1;
            PC_plus_4_in = 13'h0200;
            instruc_in = 32'h33334444;
            @(posedge clk);
            #1;


            #1;



            check_outputs(13'h0100, 32'h11112222);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Flush Functionality", test_num);


            PC_plus_4_in = 13'h0400;
            instruc_in = 32'hAAAA5555;
            @(posedge clk);
            #1;


            IF_flush = 1;
            PC_plus_4_in = 13'h0500;
            instruc_in = 32'hFFFFFFFF;
            @(posedge clk);
            #1;


            #1;



            check_outputs(13'h0400, 32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Recovery from Flush", test_num);


            IF_flush = 1;
            @(posedge clk);
            #1;


            IF_flush = 0;
            PC_plus_4_in = 13'h0888;
            instruc_in = 32'h12344321;
            @(posedge clk);
            #1;

            #1;


            check_outputs(13'h0888, 32'h12344321);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Hold vs Flush Priority", test_num);


            PC_plus_4_in = 13'h1FFF;
            instruc_in = 32'hCAFEFACE;
            @(posedge clk);
            #1;


            hold = 1;
            IF_flush = 1;
            PC_plus_4_in = 13'h0000;
            instruc_in = 32'h00000000;
            @(posedge clk);
            #1;




            #1;





            check_outputs(13'h1FFF, 32'hCAFEFACE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [12:0] expected_PC_plus_4_out;
        input [31:0] expected_instruc_out;
        begin
            if (expected_PC_plus_4_out === (expected_PC_plus_4_out ^ PC_plus_4_out ^ expected_PC_plus_4_out) &&
                expected_instruc_out === (expected_instruc_out ^ instruc_out ^ expected_instruc_out)) begin
                $display("PASS");
                $display("  Outputs: PC_plus_4_out=%h, instruc_out=%h",
                         PC_plus_4_out, instruc_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PC_plus_4_out=%h, instruc_out=%h",
                         expected_PC_plus_4_out, expected_instruc_out);
                $display("  Got:      PC_plus_4_out=%h, instruc_out=%h",
                         PC_plus_4_out, instruc_out);
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
        $dumpvars(0,IF_flush, PC_plus_4_in, clk, hold, instruc_in, PC_plus_4_out, instruc_out);
    end

endmodule
