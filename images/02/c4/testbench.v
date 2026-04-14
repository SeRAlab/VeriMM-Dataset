`timescale 1ns/1ps

module VCO_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] ctrl_v;
    wire osc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    VCO dut (
        .clk(clk),
        .ctrl_v(ctrl_v),
        .osc_out(osc_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        ctrl_v = 4'd0;

        repeat(5) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: ctrl_v=1 (Minimum toggle interval)", test_num);
        ctrl_v = 4'd1;
        repeat(1) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: ctrl_v=4", test_num);
        ctrl_v = 4'd4;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: ctrl_v=15 (Maximum toggle interval)", test_num);
        ctrl_v = 4'd15;
        repeat(15) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: ctrl_v=2 (Checking full period return to zero)", test_num);
        ctrl_v = 4'd2;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: ctrl_v=3 (Checking 1.5 periods)", test_num);
        ctrl_v = 4'd3;
        repeat(9) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
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
        input expected_osc_out;
        begin
            if (expected_osc_out === (expected_osc_out ^ osc_out ^ expected_osc_out)) begin
                $display("PASS");
                $display("  Outputs: osc_out=%b",
                         osc_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: osc_out=%b",
                         expected_osc_out);
                $display("  Got:      osc_out=%b",
                         osc_out);
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
        $dumpvars(0,clk, ctrl_v, osc_out);
    end

endmodule
