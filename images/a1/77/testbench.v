`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CE;
    reg CLK;
    reg SEL;
    reg [1:0] SI;
    wire [1:0] DO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CE(CE),
        .CLK(CLK),
        .SEL(SEL),
        .SI(SI),
        .DO(DO)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            CE = 0;
            SEL = 0;
            SI = 2'b00;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write to Reg 0", test_num);
            reset_dut();

            CE = 1;
            SEL = 0;
            SI = 2'b11;
            @(posedge CLK);
            #1;
            CE = 0;

            #1;


            check_outputs(2'b11);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write to Reg 1", test_num);
            reset_dut();

            CE = 1;
            SEL = 1;
            SI = 2'b10;
            @(posedge CLK);
            #1;
            CE = 0;

            #1;


            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Verify Persistence and Selection Switching", test_num);
            reset_dut();


            CE = 1; SEL = 0; SI = 2'b01;
            @(posedge CLK); #1;


            CE = 1; SEL = 1; SI = 2'b11;
            @(posedge CLK); #1;


            CE = 0; SEL = 0;
            #1;

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Chip Enable Disable Check", test_num);
            reset_dut();


            CE = 1; SEL = 0; SI = 2'b10;
            @(posedge CLK); #1;


            CE = 0; SEL = 0; SI = 2'b00;
            @(posedge CLK); #1;


            #1;



            check_outputs(2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sequential Writes to same register", test_num);
            reset_dut();

            CE = 1; SEL = 1; SI = 2'b01;
            @(posedge CLK); #1;
            SI = 2'b11;
            @(posedge CLK); #1;
            SI = 2'b10;
            @(posedge CLK); #1;

            #1;


            check_outputs(2'b10);
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
        input [1:0] expected_DO;
        begin
            if (expected_DO === (expected_DO ^ DO ^ expected_DO)) begin
                $display("PASS");
                $display("  Outputs: DO=%h",
                         DO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DO=%h",
                         expected_DO);
                $display("  Got:      DO=%h",
                         DO);
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
        $dumpvars(0,CE, CLK, SEL, SI, DO);
    end

endmodule
