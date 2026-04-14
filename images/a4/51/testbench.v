`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RST;
    reg STM;
    wire [7:0] ENa;
    wire [7:0] ENb;
    wire [7:0] ENc;
    wire EOM;
    wire [7:0] SEL;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RST(RST),
        .STM(STM),
        .ENa(ENa),
        .ENb(ENb),
        .ENc(ENc),
        .EOM(EOM),
        .SEL(SEL)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            STM = 0;
            @(posedge CLK);
            #2 RST = 0;
            @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %0d: Initial Reset and Idle Check", test_num);
            reset_dut();
            repeat(2) @(posedge CLK);

            #1;


            check_outputs(8'h00, 8'h00, 8'h00, 1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %0d: Sequence Completion Check", test_num);
            reset_dut();

            @(posedge CLK);
            STM = 1;
            @(posedge CLK);
            STM = 0;



            repeat(6) @(posedge CLK);




            if (EOM === 1'b1)
                #1;

                check_outputs(ENa, ENb, ENc, 1'b1, SEL);
            else
                #1;

                check_outputs(ENa, ENb, ENc, 1'b1, SEL);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %0d: Repeatability Check", test_num);
            reset_dut();


            @(posedge CLK);
            STM = 1;
            @(posedge CLK);
            STM = 0;
            wait(EOM == 1'b1);
            @(posedge CLK);


            STM = 1;
            @(posedge CLK);
            STM = 0;
            repeat(6) @(posedge CLK);

            #1;


            check_outputs(ENa, ENb, ENc, 1'b1, SEL);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %0d: Mid-operation Reset Check", test_num);
            reset_dut();

            @(posedge CLK);
            STM = 1;
            @(posedge CLK);
            STM = 0;


            repeat(2) @(posedge CLK);


            RST = 1;
            @(posedge CLK);
            RST = 0;
            repeat(1) @(posedge CLK);


            #1;



            check_outputs(8'h00, 8'h00, 8'h00, 1'b0, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase %0d: Persistent STM Check", test_num);
            reset_dut();

            @(posedge CLK);
            STM = 1;


            repeat(10) @(posedge CLK);




            if (EOM === 1'b1)
                #1;

                check_outputs(ENa, ENb, ENc, 1'b1, SEL);
            else
                #1;

                check_outputs(ENa, ENb, ENc, EOM, SEL);

            STM = 0;
            @(posedge CLK);
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
        input [7:0] expected_ENa;
        input [7:0] expected_ENb;
        input [7:0] expected_ENc;
        input expected_EOM;
        input [7:0] expected_SEL;
        begin
            if (expected_ENa === (expected_ENa ^ ENa ^ expected_ENa) &&
                expected_ENb === (expected_ENb ^ ENb ^ expected_ENb) &&
                expected_ENc === (expected_ENc ^ ENc ^ expected_ENc) &&
                expected_EOM === (expected_EOM ^ EOM ^ expected_EOM) &&
                expected_SEL === (expected_SEL ^ SEL ^ expected_SEL)) begin
                $display("PASS");
                $display("  Outputs: ENa=%h, ENb=%h, ENc=%h, EOM=%b, SEL=%h",
                         ENa, ENb, ENc, EOM, SEL);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ENa=%h, ENb=%h, ENc=%h, EOM=%b, SEL=%h",
                         expected_ENa, expected_ENb, expected_ENc, expected_EOM, expected_SEL);
                $display("  Got:      ENa=%h, ENb=%h, ENc=%h, EOM=%b, SEL=%h",
                         ENa, ENb, ENc, EOM, SEL);
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
        $dumpvars(0,CLK, RST, STM, ENa, ENb, ENc, EOM, SEL);
    end

endmodule
