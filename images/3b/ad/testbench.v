`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] data_in;
    reg sel;
    reg we;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .data_in(data_in),
        .sel(sel),
        .we(we),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        sel = 0;
        forever #5 sel = ~sel;
    end

        task reset_dut;

    begin
        we = 0;
        data_in = 0;

        @(posedge sel);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Writing 4'hA and Reading back...", test_num);
        reset_dut();


        we = 1;
        data_in = 4'hA;
        @(posedge sel);
        #2;


        we = 0;
        @(posedge sel);
        #2;

        #1;


        check_outputs(4'hA);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Writing 4'h5 and Reading back...", test_num);
        reset_dut();


        we = 1;
        data_in = 4'h5;
        @(posedge sel);
        #2;


        we = 0;
        @(posedge sel);
        #2;

        #1;


        check_outputs(4'h5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Checking data persistence when WE is low...", test_num);
        reset_dut();


        we = 1;
        data_in = 4'hF;
        @(posedge sel);
        #2;


        we = 0;
        data_in = 4'h0;


        @(posedge sel);
        #2;


        #1;



        check_outputs(4'hF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Writing 4'h0 and Reading back...", test_num);
        reset_dut();

        we = 1;
        data_in = 4'h0;
        @(posedge sel);
        #2;

        we = 0;
        @(posedge sel);
        #2;

        #1;


        check_outputs(4'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Checking stability across multiple cycles...", test_num);
        reset_dut();


        we = 1;
        data_in = 4'h9;
        @(posedge sel);
        #2;

        we = 0;

        repeat(3) @(posedge sel);
        #2;

        #1;


        check_outputs(4'h9);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sram_cell Testbench");
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
        input [3:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,data_in, sel, we, data_out);
    end

endmodule
