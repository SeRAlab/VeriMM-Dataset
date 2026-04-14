`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg EndTras;
    reg NewDataKB;
    reg ParityCoherente;
    reg Reset;
    wire Borrar;
    wire Load;
    wire New;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .EndTras(EndTras),
        .NewDataKB(NewDataKB),
        .ParityCoherente(ParityCoherente),
        .Reset(Reset),
        .Borrar(Borrar),
        .Load(Load),
        .New(New)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            Reset = 1;
            EndTras = 0;
            NewDataKB = 0;
            ParityCoherente = 0;
            repeat(2) @(posedge Clk);
            #1 Reset = 0;
            @(posedge Clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: System Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Successful Data Capture", test_num);
            reset_dut();


            @(negedge Clk); NewDataKB = 1;
            @(negedge Clk); NewDataKB = 0;


            repeat(3) @(negedge Clk);


            EndTras = 1;
            ParityCoherente = 1;
            @(negedge Clk);
            EndTras = 0;
            ParityCoherente = 0;


            #1;



            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Failed Parity Check", test_num);
            reset_dut();


            @(negedge Clk); NewDataKB = 1;
            @(negedge Clk); NewDataKB = 0;

            repeat(2) @(negedge Clk);


            EndTras = 1;
            ParityCoherente = 0;
            @(negedge Clk);
            EndTras = 0;


            #1;



            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Start Signal 'Borrar' Verification", test_num);
            reset_dut();

            @(negedge Clk);
            NewDataKB = 1;


            @(posedge Clk);
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);

            @(negedge Clk); NewDataKB = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Back-to-back Valid Transmissions", test_num);
            reset_dut();


            @(negedge Clk); NewDataKB = 1;
            @(negedge Clk); NewDataKB = 0;
            @(negedge Clk); EndTras = 1; ParityCoherente = 1;
            @(negedge Clk); EndTras = 0;


            @(negedge Clk); NewDataKB = 1;
            @(negedge Clk); NewDataKB = 0;
            @(negedge Clk); EndTras = 1; ParityCoherente = 1;
            @(negedge Clk); EndTras = 0;


            #1;



            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %03d: Reset During Transmission", test_num);
            reset_dut();

            @(negedge Clk); NewDataKB = 1;
            @(negedge Clk); NewDataKB = 0;
            repeat(2) @(negedge Clk);


            Reset = 1;
            @(posedge Clk);
            Reset = 0;


            #1;



            check_outputs(1'b0, 1'b0, 1'b0);
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
        input expected_Borrar;
        input expected_Load;
        input expected_New;
        begin
            if (expected_Borrar === (expected_Borrar ^ Borrar ^ expected_Borrar) &&
                expected_Load === (expected_Load ^ Load ^ expected_Load) &&
                expected_New === (expected_New ^ New ^ expected_New)) begin
                $display("PASS");
                $display("  Outputs: Borrar=%b, Load=%b, New=%b",
                         Borrar, Load, New);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Borrar=%b, Load=%b, New=%b",
                         expected_Borrar, expected_Load, expected_New);
                $display("  Got:      Borrar=%b, Load=%b, New=%b",
                         Borrar, Load, New);
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
        $dumpvars(0,Clk, EndTras, NewDataKB, ParityCoherente, Reset, Borrar, Load, New);
    end

endmodule
