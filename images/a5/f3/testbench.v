`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg load;
    reg nrst;
    reg [7:0] pi;
    reg si;
    wire [7:0] po;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .en(en),
        .load(load),
        .nrst(nrst),
        .pi(pi),
        .si(si),
        .po(po)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            nrst = 0;
            en = 0;
            load = 0;
            pi = 8'h00;
            si = 0;
            @(negedge clk);
            nrst = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Checking Reset State", test_num);
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Checking Parallel Load (pi=0xA5)", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            pi = 8'hA5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        reg [7:0] shift_data;
        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Checking 8-bit Serial Shift (si sequence)", test_num);
            reset_dut();
            shift_data = 8'b11001010;
            @(negedge clk);
            en = 1;
            load = 0;
            for (i = 7; i >= 0; i = i - 1) begin
                si = shift_data[i];
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(8'hCA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Checking Enable Signal Control", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            si = 1;
            @(posedge clk);
            @(negedge clk);
            en = 0;
            si = 0;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Checking Load Priority over Shift", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            en = 1;
            pi = 8'h55;
            si = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Checking Mid-operation Reset", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            pi = 8'hFF;
            @(posedge clk);
            #1;
            nrst = 0;
            #2;
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_po;
        begin
            if (expected_po === (expected_po ^ po ^ expected_po)) begin
                $display("PASS");
                $display("  Outputs: po=%h",
                         po);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: po=%h",
                         expected_po);
                $display("  Got:      po=%h",
                         po);
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
        $dumpvars(0,clk, en, load, nrst, pi, si, po);
    end

endmodule
