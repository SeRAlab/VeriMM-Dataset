`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg [3:0] Data;
    reg Enable;
    reg Initialize;
    reg Reset;
    wire [7:0] Crc;
    wire CrcError;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .Data(Data),
        .Enable(Enable),
        .Initialize(Initialize),
        .Reset(Reset),
        .Crc(Crc),
        .CrcError(CrcError)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            Reset = 1;
            Data = 4'b0;
            Enable = 0;
            Initialize = 0;
            repeat(2) @(posedge Clk);
            #1 Reset = 0;
            @(posedge Clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: System Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Initialization logic", test_num);
            reset_dut();
            @(negedge Clk);
            Initialize = 1;
            @(posedge Clk);
            #1 Initialize = 0;
            @(posedge Clk);

            #1;


            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Single Nibble Processing", test_num);
            reset_dut();
            @(negedge Clk);
            Initialize = 1;
            @(posedge Clk);
            #1 Initialize = 0;
            Data = 4'hA;
            Enable = 1;
            @(posedge Clk);
            #1 Enable = 0;

            #1;


            check_outputs(Crc, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Multiple Nibbles (Full Byte)", test_num);
            reset_dut();
            @(negedge Clk);
            Initialize = 1;
            @(posedge Clk);
            #1 Initialize = 0;
            Enable = 1;
            Data = 4'h5; @(posedge Clk);
            Data = 4'hC; @(posedge Clk);
            #1 Enable = 0;

            #1;


            check_outputs(Crc, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Enable Gating Check", test_num);
            reset_dut();
            @(negedge Clk);
            Initialize = 1; @(posedge Clk);
            #1 Initialize = 0;
            Data = 4'hF;
            Enable = 0;
            repeat(3) @(posedge Clk);

            #1;


            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Mid-calculation Reset", test_num);
            reset_dut();
            @(negedge Clk);
            Initialize = 1; @(posedge Clk);
            #1 Initialize = 0;
            Enable = 1;
            Data = 4'hA; @(posedge Clk);
            Data = 4'hB; @(posedge Clk);
            #1 Reset = 1;
            @(posedge Clk);
            #1 Reset = 0;
            #1;

            check_outputs(8'h00, 1'b0);
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
        input [7:0] expected_Crc;
        input expected_CrcError;
        begin
            if (expected_Crc === (expected_Crc ^ Crc ^ expected_Crc) &&
                expected_CrcError === (expected_CrcError ^ CrcError ^ expected_CrcError)) begin
                $display("PASS");
                $display("  Outputs: Crc=%h, CrcError=%b",
                         Crc, CrcError);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Crc=%h, CrcError=%b",
                         expected_Crc, expected_CrcError);
                $display("  Got:      Crc=%h, CrcError=%b",
                         Crc, CrcError);
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
        $dumpvars(0,Clk, Data, Enable, Initialize, Reset, Crc, CrcError);
    end

endmodule
