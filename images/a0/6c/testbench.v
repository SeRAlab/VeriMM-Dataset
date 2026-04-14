`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg [7:0] Divider;
    reg Reset;
    wire Mdc;
    wire MdcEn;
    wire MdcEn_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .Divider(Divider),
        .Reset(Reset),
        .Mdc(Mdc),
        .MdcEn(MdcEn),
        .MdcEn_n(MdcEn_n)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            Reset = 1;
            Divider = 8'h04;
            @(posedge Clk);
            #2 Reset = 0;
            @(posedge Clk);
            $display("Reset completed.");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial State after Reset", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Divider = 4, checking MdcEn pulse", test_num);
            reset_dut();
            Divider = 8'h04;


            @(posedge Clk);




            repeat(1) @(posedge Clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Divider = 4, checking Mdc High state", test_num);
            reset_dut();
            Divider = 8'h04;

            repeat(2) @(posedge Clk);
            #2;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Divider = 4, checking MdcEn_n pulse", test_num);
            reset_dut();
            Divider = 8'h04;

            repeat(3) @(posedge Clk);
            #2;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large Divider (10)", test_num);
            reset_dut();
            Divider = 8'h0A;


            repeat(4) @(posedge Clk);
            #2;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Minimum Divider check (Divider = 1)", test_num);
            reset_dut();
            Divider = 8'h01;




            @(posedge Clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full Cycle Check (Divider = 4)", test_num);
            reset_dut();
            Divider = 8'h04;

            repeat(4) @(posedge Clk);
            #2;

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
        testcase007();
        
        
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
        input expected_Mdc;
        input expected_MdcEn;
        input expected_MdcEn_n;
        begin
            if (expected_Mdc === (expected_Mdc ^ Mdc ^ expected_Mdc) &&
                expected_MdcEn === (expected_MdcEn ^ MdcEn ^ expected_MdcEn) &&
                expected_MdcEn_n === (expected_MdcEn_n ^ MdcEn_n ^ expected_MdcEn_n)) begin
                $display("PASS");
                $display("  Outputs: Mdc=%b, MdcEn=%b, MdcEn_n=%b",
                         Mdc, MdcEn, MdcEn_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Mdc=%b, MdcEn=%b, MdcEn_n=%b",
                         expected_Mdc, expected_MdcEn, expected_MdcEn_n);
                $display("  Got:      Mdc=%b, MdcEn=%b, MdcEn_n=%b",
                         Mdc, MdcEn, MdcEn_n);
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
        $dumpvars(0,Clk, Divider, Reset, Mdc, MdcEn, MdcEn_n);
    end

endmodule
