`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg POSROTAF;
    reg ROTBF;
    wire EV;
    wire IZ;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .POSROTAF(POSROTAF),
        .ROTBF(ROTBF),
        .EV(EV),
        .IZ(IZ)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            POSROTAF = 0;
            ROTBF = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            POSROTAF = 1;
            ROTBF = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            POSROTAF = 1;
            ROTBF = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            POSROTAF = 1;
            ROTBF = 1;
            @(posedge CLK);
            #1;

            POSROTAF = 0;
            ROTBF = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            POSROTAF = 1;
            ROTBF = 0;
            @(posedge CLK);
            #1;

            POSROTAF = 0;
            ROTBF = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            POSROTAF = 1;
            ROTBF = 1;
            @(posedge CLK);
            #1;

            POSROTAF = 1;
            ROTBF = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
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
        input expected_EV;
        input expected_IZ;
        begin
            if (expected_EV === (expected_EV ^ EV ^ expected_EV) &&
                expected_IZ === (expected_IZ ^ IZ ^ expected_IZ)) begin
                $display("PASS");
                $display("  Outputs: EV=%b, IZ=%b",
                         EV, IZ);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EV=%b, IZ=%b",
                         expected_EV, expected_IZ);
                $display("  Got:      EV=%b, IZ=%b",
                         EV, IZ);
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
        $dumpvars(0,CLK, POSROTAF, ROTBF, EV, IZ);
    end

endmodule
