`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLOCK_IN;
    reg RESET;
    reg [2:0] SWITCH;
    wire [3:0] LED;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLOCK_IN(CLOCK_IN),
        .RESET(RESET),
        .SWITCH(SWITCH),
        .LED(LED)
    );

    // Clock generation (10ns period)
    initial begin
        CLOCK_IN = 0;
        forever #5 CLOCK_IN = ~CLOCK_IN;
    end

        task reset_dut;

        begin
            RESET = 1;
            SWITCH = 3'b000;
            @(posedge CLOCK_IN);
            #1;
            RESET = 0;

            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Checking Reset State", test_num);
            reset_dut();
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Switch 0 - First Toggle", test_num);
            reset_dut();
            SWITCH = 3'd0;
            @(posedge CLOCK_IN);
            #1;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Switch 0 - Second Toggle (Inversion)", test_num);
            reset_dut();
            SWITCH = 3'd0;
            @(posedge CLOCK_IN);
            @(posedge CLOCK_IN);
            #1;
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Switch 1 - Pattern Check", test_num);
            reset_dut();
            SWITCH = 3'd1;
            @(posedge CLOCK_IN);
            #1;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Switch 2 - Pattern Check", test_num);
            reset_dut();
            SWITCH = 3'd2;
            @(posedge CLOCK_IN);
            #1;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Switch 3 - Pattern Check", test_num);
            reset_dut();
            SWITCH = 3'd3;
            @(posedge CLOCK_IN);
            #1;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Switch 4 - Default High State", test_num);
            reset_dut();
            SWITCH = 3'd4;
            @(posedge CLOCK_IN);
            #1;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Switch 7 - Default Toggle", test_num);
            reset_dut();
            SWITCH = 3'd7;
            @(posedge CLOCK_IN);
            @(posedge CLOCK_IN);
            #1;
            #1;

            check_outputs(4'b0000);
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
        testcase008();
        
        
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
        input [3:0] expected_LED;
        begin
            if (expected_LED === (expected_LED ^ LED ^ expected_LED)) begin
                $display("PASS");
                $display("  Outputs: LED=%h",
                         LED);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LED=%h",
                         expected_LED);
                $display("  Got:      LED=%h",
                         LED);
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
        $dumpvars(0,CLOCK_IN, RESET, SWITCH, LED);
    end

endmodule
