`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] bus;
    reg ldir;
    reg t3;
    wire [7:0] ir;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bus(bus),
        .ldir(ldir),
        .t3(t3),
        .ir(ir)
    );

    // Clock generation (10ns period)
    initial begin
        t3 = 0;
        forever #5 t3 = ~t3;
    end

        task reset_dut;

        begin
            ldir = 0;
            bus = 8'h00;
            @(negedge t3);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test Case %0d: Loading 0xA5 into IR", test_num);
            ldir = 1;
            bus = 8'hA5;
            @(posedge t3);
            #2;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test Case %0d: Verify IR does not change when ldir=0", test_num);


            ldir = 1;
            bus = 8'h55;
            @(posedge t3);
            #2;


            ldir = 0;
            bus = 8'hAA;
            @(posedge t3);
            #2;

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test Case %0d: Successive updates", test_num);

            ldir = 1;
            bus = 8'hFF;
            @(posedge t3);
            #2;

            bus = 8'h12;
            @(posedge t3);
            #2;

            #1;


            check_outputs(8'h12);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test Case %0d: Loading All-Ones (0xFF)", test_num);
            ldir = 1;
            bus = 8'hFF;
            @(posedge t3);
            #2;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test Case %0d: Loading All-Zeros (0x00)", test_num);
            ldir = 1;
            bus = 8'h00;
            @(posedge t3);
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
        input [7:0] expected_ir;
        begin
            if (expected_ir === (expected_ir ^ ir ^ expected_ir)) begin
                $display("PASS");
                $display("  Outputs: ir=%h",
                         ir);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ir=%h",
                         expected_ir);
                $display("  Got:      ir=%h",
                         ir);
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
        $dumpvars(0,bus, ldir, t3, ir);
    end

endmodule
