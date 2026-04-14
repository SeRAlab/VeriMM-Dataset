`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg DS;
    reg ESEL;
    reg FIXHOLD;
    reg IE;
    reg INEN;
    reg IQC;
    reg IQCS;
    reg IQE;
    reg IQR;
    reg OQE;
    reg OQI;
    reg OSEL;
    reg WPD;
    wire IQZ;
    wire IZ;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DS(DS),
        .ESEL(ESEL),
        .FIXHOLD(FIXHOLD),
        .IE(IE),
        .INEN(INEN),
        .IQC(IQC),
        .IQCS(IQCS),
        .IQE(IQE),
        .IQR(IQR),
        .OQE(OQE),
        .OQI(OQI),
        .OSEL(OSEL),
        .WPD(WPD),
        .IQZ(IQZ),
        .IZ(IZ)
    );

        task reset_dut;

        begin
            DS = 0; ESEL = 0; FIXHOLD = 0; IE = 0; INEN = 0;
            IQC = 0; IQCS = 0; IQE = 0; IQR = 1; OQE = 0;
            OQI = 0; OSEL = 0; WPD = 0;
            IP_drive_en = 0; IP_drive_val = 0;
            #20;
            IQR = 0;
            #10;
        end
        endtask
    task pulse_clock;

        begin
            #5 IQC = 1;
            #5 IQC = 0;
            #5;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            IQR = 1;
            pulse_clock();
            $display("Testcase %03d: Reset Check", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            IE = 1;
            INEN = 1;
            IP_drive_en = 1;
            IP_drive_val = 1;
            #10;
            $display("Testcase %03d: Input Enable and Combinatorial Path (IZ)", test_num);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            IE = 0;
            INEN = 1;
            IP_drive_en = 1;
            IP_drive_val = 1;
            #10;
            $display("Testcase %03d: Input Gating (IE=0)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            IE = 1;
            INEN = 1;
            IQE = 1;
            IQR = 0;
            IP_drive_en = 1;
            IP_drive_val = 1;
            #5;
            pulse_clock();
            #5;
            $display("Testcase %03d: Registered Input (IQZ)", test_num);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            IE = 1; INEN = 1; IQE = 1;
            IP_drive_en = 1; IP_drive_val = 1;
            pulse_clock();

            IQE = 0;
            IP_drive_val = 0;
            pulse_clock();
            #5;
            $display("Testcase %03d: Input Latch Enable (IQE=0)", test_num);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            OQE = 1;
            OQI = 1;
            OSEL = 0;
            ESEL = 0;
            IP_drive_en = 0;
            IE = 1;
            INEN = 1;
            #10;
            $display("Testcase %03d: Output Drive and Loopback to IZ", test_num);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            OQE = 0;
            OQI = 1;
            IP_drive_en = 1;
            IP_drive_val = 0;
            IE = 1;
            INEN = 1;
            #10;
            $display("Testcase %03d: Output Disable (High-Z) External Drive", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            IE = 1; INEN = 1; IQE = 1;
            IP_drive_en = 1; IP_drive_val = 1;
            pulse_clock();
            IQR = 1;
            #5;
            pulse_clock();
            #5;
            $display("Testcase %03d: Mid-operation Register Clear", test_num);
            #1;

            check_outputs(1'b0, 1'b1);
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
        input expected_IQZ;
        input expected_IZ;
        begin
            if (expected_IQZ === (expected_IQZ ^ IQZ ^ expected_IQZ) &&
                expected_IZ === (expected_IZ ^ IZ ^ expected_IZ)) begin
                $display("PASS");
                $display("  Outputs: IQZ=%b, IZ=%b",
                         IQZ, IZ);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IQZ=%b, IZ=%b",
                         expected_IQZ, expected_IZ);
                $display("  Got:      IQZ=%b, IZ=%b",
                         IQZ, IZ);
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
        $dumpvars(0,DS, ESEL, FIXHOLD, IE, INEN, IQC, IQCS, IQE, IQR, OQE, OQI, OSEL, WPD, IQZ, IZ);
    end

endmodule
