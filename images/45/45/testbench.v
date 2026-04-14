`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock0;
    reg [26:0] dataa;
    reg [26:0] datab;
    reg ena0;
    wire [53:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock0(clock0),
        .dataa(dataa),
        .datab(datab),
        .ena0(ena0),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clock0 = 0;
        forever #5 clock0 = ~clock0;
    end

        task reset_dut;

    begin
        ena0 = 0;
        dataa = 0;
        datab = 0;
        @(posedge clock0);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Small positive values (10 * 20 * 2)", test_num);
        reset_dut();
        dataa = 27'd10;
        datab = 27'd20;
        ena0 = 1;
        @(posedge clock0);
        ena0 = 0;
        repeat(2) @(posedge clock0);
        #1;

        check_outputs(54'd400);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero multiplication", test_num);
        reset_dut();
        dataa = 27'd0;
        datab = 27'd123456;
        ena0 = 1;
        @(posedge clock0);
        ena0 = 0;
        repeat(2) @(posedge clock0);
        #1;

        check_outputs(54'd0);
    end
        endtask

    task testcase003;

    reg [54:0] full_calc;
    begin
        test_num = test_num + 1;
        $display("Test %0d: Max unsigned values (truncation check)", test_num);
        reset_dut();
        dataa = 27'h7FFFFFF;
        datab = 27'h7FFFFFF;
        ena0 = 1;
        @(posedge clock0);
        ena0 = 0;
        repeat(2) @(posedge clock0);

        full_calc = (55'h7FFFFFF * 55'h7FFFFFF) * 2;
        #1;

        check_outputs(full_calc[53:0]);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Enable (ena0) gating test", test_num);
        reset_dut();


        dataa = 27'd5;
        datab = 27'd5;
        ena0 = 1;
        @(posedge clock0);


        dataa = 27'd100;
        datab = 27'd100;
        ena0 = 0;
        @(posedge clock0);

        repeat(2) @(posedge clock0);

        #1;


        check_outputs(54'd50);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Power of 2 values", test_num);
        reset_dut();
        dataa = (27'b1 << 10);
        datab = (27'b1 << 10);
        ena0 = 1;
        @(posedge clock0);
        ena0 = 0;
        repeat(2) @(posedge clock0);
        #1;

        check_outputs(54'b1 << 21);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Large bit patterns", test_num);
        reset_dut();
        dataa = 27'h4000000;
        datab = 27'd2;
        ena0 = 1;
        @(posedge clock0);
        ena0 = 0;
        repeat(2) @(posedge clock0);
        #1;

        check_outputs(54'h10000000);
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
        input [53:0] expected_result;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
        $dumpvars(0,clock0, dataa, datab, ena0, result);
    end

endmodule
