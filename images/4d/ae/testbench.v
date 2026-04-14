`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [5:0] Address;
    reg Clock;
    reg [6:0] Din;
    reg Reset;
    reg WriteEnabled;
    wire [6:0] Dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Address(Address),
        .Clock(Clock),
        .Din(Din),
        .Reset(Reset),
        .WriteEnabled(WriteEnabled),
        .Dout(Dout)
    );

    // Clock generation (10ns period)
    initial begin
        Clock = 0;
        forever #5 Clock = ~Clock;
    end

        task reset_dut;

        begin
            Address = 0;
            Din = 0;
            WriteEnabled = 0;
            Reset = 1;
            #15;
            Reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            Address = 6'd0;
            #5;



            #1;




            check_outputs(Dout);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            Address = 6'd10;
            Din = 7'h41;
            WriteEnabled = 1;
            @(posedge Clock);
            #2;
            WriteEnabled = 0;
            #5;
            #1;

            check_outputs(7'h41);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            Address = 6'd39;
            Din = 7'h5A;
            WriteEnabled = 1;
            @(posedge Clock);
            #2;
            WriteEnabled = 0;
            #5;
            #1;

            check_outputs(7'h5A);
        end
        endtask

    task testcase004;

        reg [6:0] initial_val;
        begin
            reset_dut();
            Address = 6'd5;
            initial_val = Dout;
            Din = 7'h7F;
            WriteEnabled = 0;
            @(posedge Clock);
            #2;
            #1;

            check_outputs(initial_val);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            Address = 6'd20;
            Din = 7'h11;
            WriteEnabled = 1;
            @(posedge Clock);
            #2;

            Din = 7'h22;
            @(posedge Clock);
            #2;
            WriteEnabled = 0;
            #5;
            #1;

            check_outputs(7'h22);
        end
        endtask

    task testcase006;

        reg [6:0] reset_val;
        begin
            reset_dut();

            Address = 6'd15;
            #1;
            reset_val = Dout;


            Din = 7'h55;
            WriteEnabled = 1;
            @(posedge Clock);
            #2;


            Reset = 1;
            #10;
            Reset = 0;
            #5;


            #1;



            check_outputs(reset_val);
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
        input [6:0] expected_Dout;
        begin
            if (expected_Dout === (expected_Dout ^ Dout ^ expected_Dout)) begin
                $display("PASS");
                $display("  Outputs: Dout=%h",
                         Dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Dout=%h",
                         expected_Dout);
                $display("  Got:      Dout=%h",
                         Dout);
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
        $dumpvars(0,Address, Clock, Din, Reset, WriteEnabled, Dout);
    end

endmodule
