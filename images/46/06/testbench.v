`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg iCLK;
    reg lap;
    wire [7:0] giatri;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iCLK(iCLK),
        .lap(lap),
        .giatri(giatri)
    );

    // Clock generation (10ns period)
    initial begin
        iCLK = 0;
        forever #5 iCLK = ~iCLK;
    end

        task reset_dut;

    begin
        lap = 0;
        @(posedge iCLK);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Initial Reset Check", test_num);
        reset_dut();
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Increment to 5", test_num);
        reset_dut();
        lap = 1;
        repeat(5) @(posedge iCLK);
        #1;
        #1;

        check_outputs(8'd5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Long Increment (Count to 50)", test_num);
        reset_dut();
        lap = 1;
        repeat(50) @(posedge iCLK);
        #1;
        #1;

        check_outputs(8'd50);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Reset Mid-count", test_num);
        reset_dut();
        lap = 1;
        repeat(10) @(posedge iCLK);
        lap = 0;
        @(posedge iCLK);
        #1;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Counter Overflow (255 to 0)", test_num);
        reset_dut();
        lap = 1;
        repeat(255) @(posedge iCLK);

        @(posedge iCLK);
        #1;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Recovery after Reset", test_num);
        reset_dut();
        lap = 1;
        repeat(10) @(posedge iCLK);
        lap = 0;
        @(posedge iCLK);
        lap = 1;
        repeat(3) @(posedge iCLK);
        #1;
        #1;

        check_outputs(8'd3);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Static Reset Maintenance", test_num);
        reset_dut();
        lap = 0;
        repeat(10) @(posedge iCLK);
        #1;
        #1;

        check_outputs(8'd0);
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
        input [7:0] expected_giatri;
        begin
            if (expected_giatri === (expected_giatri ^ giatri ^ expected_giatri)) begin
                $display("PASS");
                $display("  Outputs: giatri=%h",
                         giatri);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: giatri=%h",
                         expected_giatri);
                $display("  Got:      giatri=%h",
                         giatri);
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
        $dumpvars(0,iCLK, lap, giatri);
    end

endmodule
