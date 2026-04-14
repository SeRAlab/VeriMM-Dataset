`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Stall;
    reg clock;
    reg [31:0] pc_next;
    reg reset;
    wire [31:0] pc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Stall(Stall),
        .clock(clock),
        .pc_next(pc_next),
        .reset(reset),
        .pc(pc)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            @(negedge clock);
            reset = 1;
            Stall = 0;
            pc_next = 32'h0;
            @(negedge clock);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Reset", test_num);
            reset_dut();

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Normal PC Update", test_num);
            reset_dut();
            @(negedge clock);
            pc_next = 32'hDEADBEEF;
            Stall = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Stall Functionality", test_num);
            reset_dut();


            @(negedge clock);
            pc_next = 32'h12345678;
            Stall = 0;
            @(posedge clock);


            @(negedge clock);
            Stall = 1;
            pc_next = 32'h87654321;
            @(posedge clock);
            #1;


            #1;



            check_outputs(32'h12345678);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Recovery after Stall", test_num);
            reset_dut();


            @(negedge clock);
            pc_next = 32'hAAAA_AAAA;
            Stall = 1;
            @(posedge clock);


            @(negedge clock);
            Stall = 0;
            pc_next = 32'hBBBB_BBBB;
            @(posedge clock);
            #1;

            #1;


            check_outputs(32'hBBBB_BBBB);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Reset priority over Stall", test_num);
            reset_dut();


            @(negedge clock);
            pc_next = 32'hFFFF_FFFF;
            Stall = 0;
            @(posedge clock);


            @(negedge clock);
            reset = 1;
            Stall = 1;
            pc_next = 32'h0000_1111;
            @(posedge clock);
            #1;


            #1;



            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Sequential PC Updates", test_num);
            reset_dut();

            @(negedge clock);
            pc_next = 32'h1;
            @(posedge clock);

            @(negedge clock);
            pc_next = 32'h2;
            @(posedge clock);

            @(negedge clock);
            pc_next = 32'h3;
            @(posedge clock);
            #1;

            #1;


            check_outputs(32'h3);
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
        input [31:0] expected_pc;
        begin
            if (expected_pc === (expected_pc ^ pc ^ expected_pc)) begin
                $display("PASS");
                $display("  Outputs: pc=%h",
                         pc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pc=%h",
                         expected_pc);
                $display("  Got:      pc=%h",
                         pc);
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
        $dumpvars(0,Stall, clock, pc_next, reset, pc);
    end

endmodule
