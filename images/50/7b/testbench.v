`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CDI;
    reg CE;
    reg CLK;
    reg I0;
    reg I1;
    reg I2;
    reg I3;
    reg I4;
    wire CDO;
    wire O5;
    wire O6;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CDI(CDI),
        .CE(CE),
        .CLK(CLK),
        .I0(I0),
        .I1(I1),
        .I2(I2),
        .I3(I3),
        .I4(I4),
        .CDO(CDO),
        .O5(O5),
        .O6(O6)
    );

        task reset_dut;

        integer i;
        begin
            CE = 1;
            CDI = 0;
            I4 = 0; I3 = 0; I2 = 0; I1 = 0; I0 = 0;
            repeat (33) @(posedge CLK);
            CE = 0;
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            @(posedge CLK);
            CE = 1; CDI = 1;
            @(posedge CLK);
            CE = 0;
            {I4, I3, I2, I1, I0} = 5'b00000;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(posedge CLK);
            CE = 1; CDI = 1;
            @(posedge CLK);
            CE = 0; CDI = 0;
            repeat (5) @(posedge CLK);
            {I4, I3, I2, I1, I0} = 5'b00000;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            CE = 1; CDI = 1;
            @(posedge CLK);
            CDI = 0;
            repeat (15) @(posedge CLK);
            CE = 0;
            {I4, I3, I2, I1, I0} = 5'd15;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            CE = 1; CDI = 1;
            @(posedge CLK);
            CDI = 0;
            repeat (31) @(posedge CLK);
            CE = 0;
            {I4, I3, I2, I1, I0} = 5'd31;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            CE = 1;
            CDI = 1; repeat (2) @(posedge CLK);
            CDI = 0; repeat (2) @(posedge CLK);
            CE = 0;

            {I4, I3, I2, I1, I0} = 5'd0; #1;
            if (O6 !== 1'b0) $display("Subtest A Fail");

            {I4, I3, I2, I1, I0} = 5'd2; #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
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
        input expected_CDO;
        input expected_O5;
        input expected_O6;
        begin
            if (expected_CDO === (expected_CDO ^ CDO ^ expected_CDO) &&
                expected_O5 === (expected_O5 ^ O5 ^ expected_O5) &&
                expected_O6 === (expected_O6 ^ O6 ^ expected_O6)) begin
                $display("PASS");
                $display("  Outputs: CDO=%b, O5=%b, O6=%b",
                         CDO, O5, O6);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CDO=%b, O5=%b, O6=%b",
                         expected_CDO, expected_O5, expected_O6);
                $display("  Got:      CDO=%b, O5=%b, O6=%b",
                         CDO, O5, O6);
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
        $dumpvars(0,CDI, CE, CLK, I0, I1, I2, I3, I4, CDO, O5, O6);
    end

endmodule
