`timescale 1ns/1ps

module Shift_Register_Left_tb;

    // Testbench signals (sequential circuit)
    reg Clock;
    reg [31:0] Data;
    reg Enable;
    wire [31:0] Shifted_Data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Shift_Register_Left dut (
        .Clock(Clock),
        .Data(Data),
        .Enable(Enable),
        .Shifted_Data(Shifted_Data)
    );

        task reset_dut;

        begin
            Clock = 0;
            Data = 32'h0;
            Enable = 0;
            #250;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Enable=0 (Pass-through)");
            reset_dut();
            Data = 32'hA5A5A5A5;
            Enable = 0;
            #500;
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Enable=1, Shift 0x1 left");
            reset_dut();
            Data = 32'h00000001;
            Enable = 1;
            #500;
            #1;

            check_outputs(32'h00000002);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Enable=1, Shift 0x40000000 left");
            reset_dut();
            Data = 32'h40000000;
            Enable = 1;
            #500;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Enable=1, Shift 0x80000000 left (Overflow)");
            reset_dut();
            Data = 32'h80000000;
            Enable = 1;
            #500;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Enable=1, Shift 0x55555555 left");
            reset_dut();
            Data = 32'h55555555;
            Enable = 1;
            #500;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Enable=1, Shift 0x0 left");
            reset_dut();
            Data = 32'h00000000;
            Enable = 1;
            #500;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Enable=1, Shift 0xFFFFFFFF left");
            reset_dut();
            Data = 32'hFFFFFFFF;
            Enable = 1;
            #500;
            #1;

            check_outputs(32'hFFFFFFFE);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Enable=0, Data=0xDEADBEEF");
            reset_dut();
            Data = 32'hDEADBEEF;
            Enable = 0;
            #500;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Shift_Register_Left Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [31:0] expected_Shifted_Data;
        begin
            if (expected_Shifted_Data === (expected_Shifted_Data ^ Shifted_Data ^ expected_Shifted_Data)) begin
                $display("PASS");
                $display("  Outputs: Shifted_Data=%h",
                         Shifted_Data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Shifted_Data=%h",
                         expected_Shifted_Data);
                $display("  Got:      Shifted_Data=%h",
                         Shifted_Data);
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
        $dumpvars(0,Clock, Data, Enable, Shifted_Data);
    end

endmodule
