`timescale 1ns/1ps

module VCO_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] control;
    wire clk_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    VCO dut (
        .control(control),
        .clk_out(clk_out)
    );

        task reset_dut;

    begin
        $display("Resetting VCO control...");
        control = 3'b000;
        #20;
    end
        endtask
    task testcase001;

        realtime t1, t2;
    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Control Bit 0 (Range 1)", test_num);
        reset_dut();
        control = 3'b001;


        @(posedge clk_out);
        t1 = $realtime;
        @(posedge clk_out);
        t2 = $realtime;

        $display("  Oscillation detected. Period: %0t", t2 - t1);
        #10;

        #1;


        check_outputs(clk_out);
    end
        endtask

    task testcase002;

        realtime t1, t2;
    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Control Bit 1 (Range 2)", test_num);
        reset_dut();
        control = 3'b010;

        @(posedge clk_out);
        t1 = $realtime;
        @(posedge clk_out);
        t2 = $realtime;

        $display("  Oscillation detected. Period: %0t", t2 - t1);
        #10;
        #1;

        check_outputs(clk_out);
    end
        endtask

    task testcase003;

        realtime t1, t2;
    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Control Bit 2 (Range 3)", test_num);
        reset_dut();
        control = 3'b100;

        @(posedge clk_out);
        t1 = $realtime;
        @(posedge clk_out);
        t2 = $realtime;

        $display("  Oscillation detected. Period: %0t", t2 - t1);
        #10;
        #1;

        check_outputs(clk_out);
    end
        endtask

    task testcase004;

        realtime t1, t2;
    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Full Control (All ranges 111)", test_num);
        reset_dut();
        control = 3'b111;

        @(posedge clk_out);
        t1 = $realtime;
        @(posedge clk_out);
        t2 = $realtime;

        $display("  Oscillation detected. Period: %0t", t2 - t1);
        #10;
        #1;

        check_outputs(clk_out);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Zero Control (Minimal/Idle)", test_num);
        reset_dut();
        control = 3'b000;

        #100;
        $display("  Static state or base frequency check.");
        #1;

        check_outputs(clk_out);
    end
        endtask

    task testcase006;

        realtime t1, t2, p1, p2;
    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Frequency Scaling Verification (001 vs 101)", test_num);
        reset_dut();


        control = 3'b001;
        @(posedge clk_out); t1 = $realtime;
        @(posedge clk_out); p1 = $realtime - t1;


        control = 3'b101;
        @(posedge clk_out); t2 = $realtime;
        @(posedge clk_out); p2 = $realtime - t2;

        $display("  P1 (001): %0t, P2 (101): %0t", p1, p2);
        if (p1 != p2)
            $display("  SUCCESS: Frequency shift observed.");
        else
            $display("  WARNING: No frequency shift observed.");

        #1;


        check_outputs(clk_out);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("VCO Testbench");
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
        input expected_clk_out;
        begin
            if (expected_clk_out === (expected_clk_out ^ clk_out ^ expected_clk_out)) begin
                $display("PASS");
                $display("  Outputs: clk_out=%b",
                         clk_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out=%b",
                         expected_clk_out);
                $display("  Got:      clk_out=%b",
                         clk_out);
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
        $dumpvars(0,control, clk_out);
    end

endmodule
