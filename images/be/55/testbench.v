`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg activecolumn;
    reg activegroup;
    reg [15:0] lData_0;
    reg [15:0] lData_1;
    reg [15:0] lData_2;
    reg [15:0] lData_3;
    reg [15:0] lData_4;
    reg [15:0] lData_5;
    reg [15:0] lData_6;
    reg [15:0] lData_7;
    reg load;
    wire [15:0] data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .activecolumn(activecolumn),
        .activegroup(activegroup),
        .lData_0(lData_0),
        .lData_1(lData_1),
        .lData_2(lData_2),
        .lData_3(lData_3),
        .lData_4(lData_4),
        .lData_5(lData_5),
        .lData_6(lData_6),
        .lData_7(lData_7),
        .load(load),
        .data(data)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            CLK = 0;
            activecolumn = 0;
            activegroup = 0;
            load = 0;
            lData_0 = 16'h0;
            lData_1 = 16'h0;
            lData_2 = 16'h0;
            lData_3 = 16'h0;
            lData_4 = 16'h0;
            lData_5 = 16'h0;
            lData_6 = 16'h0;
            lData_7 = 16'h0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Load data only", test_num);
            reset_dut();
            lData_0 = 16'hAAAA; lData_1 = 16'hBBBB; lData_2 = 16'hCCCC; lData_3 = 16'hDDDD;
            lData_4 = 16'hEEEE; lData_5 = 16'hFFFF; lData_6 = 16'h1234; lData_7 = 16'h5678;
            load = 1;
            @(posedge CLK);
            #1;
            load = 0;
            activecolumn = 1;
            activegroup = 1;
            #1;

            check_outputs(16'h5678);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Load and shift once", test_num);
            reset_dut();
            lData_0 = 16'h0001; lData_1 = 16'h0002; lData_2 = 16'h0003; lData_3 = 16'h0004;
            lData_4 = 16'h0005; lData_5 = 16'h0006; lData_6 = 16'h0007; lData_7 = 16'h0008;
            load = 1;
            @(posedge CLK);
            #1;
            load = 0;
            activecolumn = 1;
            activegroup = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(16'h0007);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Load and shift four times", test_num);
            reset_dut();
            lData_0 = 16'h0001; lData_1 = 16'h0002; lData_2 = 16'h0003; lData_3 = 16'h0004;
            lData_4 = 16'h0005; lData_5 = 16'h0006; lData_6 = 16'h0007; lData_7 = 16'h0008;
            load = 1;
            @(posedge CLK);
            #1;
            load = 0;
            activecolumn = 1;
            activegroup = 1;
            repeat(4) @(posedge CLK);
            #1;
            #1;

            check_outputs(16'h0004);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Load and shift seven times", test_num);
            reset_dut();
            lData_0 = 16'hCAFE; lData_1 = 16'hBABE; lData_2 = 16'hDEAD; lData_3 = 16'hBEEF;
            lData_4 = 16'h1111; lData_5 = 16'h2222; lData_6 = 16'h3333; lData_7 = 16'h4444;
            load = 1;
            @(posedge CLK);
            #1;
            load = 0;
            activecolumn = 1;
            activegroup = 1;
            repeat(7) @(posedge CLK);
            #1;
            #1;

            check_outputs(16'hCAFE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Load and shift eight times", test_num);
            reset_dut();
            lData_7 = 16'hFFFF;
            load = 1;
            @(posedge CLK);
            #1;
            load = 0;
            activecolumn = 1;
            activegroup = 1;
            repeat(8) @(posedge CLK);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Test enables (no shift if inactive)", test_num);
            reset_dut();
            lData_6 = 16'hAAAA; lData_7 = 16'h5555;
            load = 1;
            @(posedge CLK);
            #1;
            load = 0;
            activecolumn = 0;
            activegroup = 1;
            @(posedge CLK);
            #1;

            activecolumn = 1;
            #1;

            check_outputs(16'h5555);
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
        input [15:0] expected_data;
        begin
            if (expected_data === (expected_data ^ data ^ expected_data)) begin
                $display("PASS");
                $display("  Outputs: data=%h",
                         data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h",
                         expected_data);
                $display("  Got:      data=%h",
                         data);
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
        $dumpvars(0,CLK, activecolumn, activegroup, lData_0, lData_1, lData_2, lData_3, lData_4, lData_5, lData_6, lData_7, load, data);
    end

endmodule
