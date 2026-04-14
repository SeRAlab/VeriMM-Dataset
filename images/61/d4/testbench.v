`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg IN;
    reg RST;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .IN(IN),
        .RST(RST)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 0;
            IN = 0;
            @(posedge CLK);
            #1;
            RST = 1;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();


            #1;



            check_outputs(2'b00, 2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            IN = 1;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(2'b10, 2'b10, 2'b10);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            IN = 1;
            @(posedge CLK);
            #1;

            IN = 0;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(2'b00, 2'b00, 2'b00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            IN = 1;
            @(posedge CLK);
            #1;

            IN = 0;


            @(posedge CLK);
            #1;


            #1;



            check_outputs(2'b00, 2'b00, 2'b00);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            IN = 1;
            @(posedge CLK);
            #1;
            RST = 0;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(2'b00, 2'b00, 2'b00);
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
        begin
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
        $dumpvars(0,CLK, IN, RST);
    end

endmodule
