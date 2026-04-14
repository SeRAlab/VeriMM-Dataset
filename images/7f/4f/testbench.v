`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] PinA;
    reg PinCCLR;
    reg PinCLK;
    reg PinOE;
    wire [7:0] PinSIN;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PinA(PinA),
        .PinCCLR(PinCCLR),
        .PinCLK(PinCLK),
        .PinOE(PinOE),
        .PinSIN(PinSIN)
    );

    // Clock generation (10ns period)
    initial begin
        PinCLK = 0;
        forever #5 PinCLK = ~PinCLK;
    end

        task reset_dut;

        begin
            PinCCLR = 0;
            PinOE = 1;
            PinA = 8'h00;
            @(posedge PinCLK);
            #1;
            PinCCLR = 1;
            @(posedge PinCLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Initial Reset State Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single Shift-XOR with 0xFF", test_num);
            reset_dut();
            PinA = 8'hFF;
            @(posedge PinCLK);
            #1;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Double Shift-XOR sequence", test_num);
            reset_dut();


            PinA = 8'h55;
            @(posedge PinCLK);
            #1;


            PinA = 8'h01;
            @(posedge PinCLK);
            #1;

            #1;


            check_outputs(8'hAB);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Output Enable (PinOE) Check", test_num);
            reset_dut();

            PinA = 8'hAA;
            @(posedge PinCLK);
            #1;

            PinOE = 0;
            #1;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Synchronous Clear during operation", test_num);
            reset_dut();

            PinA = 8'hFF;
            @(posedge PinCLK);
            #1;

            PinCCLR = 0;
            @(posedge PinCLK);
            #1;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: MSB Overflow logic check", test_num);
            reset_dut();


            PinA = 8'h80;
            @(posedge PinCLK);
            #1;


            PinA = 8'h01;
            @(posedge PinCLK);
            #1;

            #1;


            check_outputs(8'h01);
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
        input [7:0] expected_PinSIN;
        begin
            if (expected_PinSIN === (expected_PinSIN ^ PinSIN ^ expected_PinSIN)) begin
                $display("PASS");
                $display("  Outputs: PinSIN=%h",
                         PinSIN);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PinSIN=%h",
                         expected_PinSIN);
                $display("  Got:      PinSIN=%h",
                         PinSIN);
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
        $dumpvars(0,PinA, PinCCLR, PinCLK, PinOE, PinSIN);
    end

endmodule
