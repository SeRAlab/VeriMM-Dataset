`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [9:0] sw;
    wire [15:0] portout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .sw(sw),
        .portout(portout)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            sw = 10'd0;
            @(posedge clock);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros", test_num);
            reset_dut();
            sw = 10'h000;
            @(posedge clock);
            #2;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones", test_num);
            reset_dut();
            sw = 10'h3FF;
            @(posedge clock);
            #2;

            #1;


            check_outputs(16'h03FF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Pattern 1010...", test_num);
            reset_dut();
            sw = 10'h2AA;
            @(posedge clock);
            #2;
            #1;

            check_outputs(16'h02AA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Pattern 0101...", test_num);
            reset_dut();
            sw = 10'h155;
            @(posedge clock);
            #2;
            #1;

            check_outputs(16'h0155);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: LSB Only", test_num);
            reset_dut();
            sw = 10'h001;
            @(posedge clock);
            #2;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input MSB Only", test_num);
            reset_dut();
            sw = 10'h200;
            @(posedge clock);
            #2;
            #1;

            check_outputs(16'h0200);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronous Capture Check", test_num);
            reset_dut();
            sw = 10'h0FF;
            @(posedge clock);
            #2;

            sw = 10'h000;
            #5;

            #1;


            check_outputs(16'h00FF);
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
        input [15:0] expected_portout;
        begin
            if (expected_portout === (expected_portout ^ portout ^ expected_portout)) begin
                $display("PASS");
                $display("  Outputs: portout=%h",
                         portout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: portout=%h",
                         expected_portout);
                $display("  Got:      portout=%h",
                         portout);
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
        $dumpvars(0,clock, sw, portout);
    end

endmodule
