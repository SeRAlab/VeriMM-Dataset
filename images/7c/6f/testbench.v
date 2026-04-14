`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] Btns;
    reg Clock;
    reg [7:0] Din;
    reg Reset;
    reg Sample;
    reg Turbo;
    wire [3:0] Debug;
    wire [7:0] Dout;
    wire Dval;
    wire [5:0] GPO;
    wire [7:0] IP;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Btns(Btns),
        .Clock(Clock),
        .Din(Din),
        .Reset(Reset),
        .Sample(Sample),
        .Turbo(Turbo),
        .Debug(Debug),
        .Dout(Dout),
        .Dval(Dval),
        .GPO(GPO),
        .IP(IP)
    );

    // Clock generation (10ns period)
    initial begin
        Clock = 0;
        forever #5 Clock = ~Clock;
    end

        task reset_dut;

        begin
            Reset = 1;
            Btns = 3'b000;
            Din = 8'h00;
            Sample = 0;
            Turbo = 0;
            @(posedge Clock);
            #2;
            Reset = 0;
            @(posedge Clock);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset logic check", test_num);


            Reset = 1;
            Btns = 3'b111;
            Din = 8'hFF;
            @(posedge Clock);
            #2;



            #1;




            check_outputs(4'h0, 8'h00, 1'b0, 6'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Normal operation GPO check", test_num);

            reset_dut();

            Reset = 0;
            @(posedge Clock);
            #2;


            #1;



            check_outputs(4'h0, 8'h00, 1'b0, 6'h3F, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input independence check", test_num);

            reset_dut();

            Reset = 0;
            Btns = 3'b101;
            Din = 8'hA5;
            Sample = 1;
            Turbo = 1;


            repeat(3) @(posedge Clock);
            #2;


            #1;



            check_outputs(4'h0, 8'h00, 1'b0, 6'h3F, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Re-assert reset check", test_num);


            Reset = 0;
            @(posedge Clock);
            #2;


            Reset = 1;
            @(posedge Clock);
            #2;


            #1;



            check_outputs(4'h0, 8'h00, 1'b0, 6'h00, 8'h00);
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
        input [3:0] expected_Debug;
        input [7:0] expected_Dout;
        input expected_Dval;
        input [5:0] expected_GPO;
        input [7:0] expected_IP;
        begin
            if (expected_Debug === (expected_Debug ^ Debug ^ expected_Debug) &&
                expected_Dout === (expected_Dout ^ Dout ^ expected_Dout) &&
                expected_Dval === (expected_Dval ^ Dval ^ expected_Dval) &&
                expected_GPO === (expected_GPO ^ GPO ^ expected_GPO) &&
                expected_IP === (expected_IP ^ IP ^ expected_IP)) begin
                $display("PASS");
                $display("  Outputs: Debug=%h, Dout=%h, Dval=%b, GPO=%h, IP=%h",
                         Debug, Dout, Dval, GPO, IP);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Debug=%h, Dout=%h, Dval=%b, GPO=%h, IP=%h",
                         expected_Debug, expected_Dout, expected_Dval, expected_GPO, expected_IP);
                $display("  Got:      Debug=%h, Dout=%h, Dval=%b, GPO=%h, IP=%h",
                         Debug, Dout, Dval, GPO, IP);
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
        $dumpvars(0,Btns, Clock, Din, Reset, Sample, Turbo, Debug, Dout, Dval, GPO, IP);
    end

endmodule
