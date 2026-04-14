`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg i_Clk;
    reg i_Touch;
    wire o_Light;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_Clk(i_Clk),
        .i_Touch(i_Touch),
        .o_Light(o_Light)
    );

    // Clock generation (10ns period)
    initial begin
        i_Clk = 0;
        forever #5 i_Clk = ~i_Clk;
    end

        task reset_dut;

        begin
            i_Touch = 0;
            repeat(5) @(posedge i_Clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial State Check", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Touch Trigger Logic", test_num);
            reset_dut();


            i_Touch = 1;
            @(posedge i_Clk);
            i_Touch = 0;
            @(posedge i_Clk);


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Display Latch Logic", test_num);
            reset_dut();


            i_Touch = 1;
            @(posedge i_Clk);
            i_Touch = 0;


            repeat(100) @(posedge i_Clk);


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Timer Reset via Repeated Touch", test_num);
            reset_dut();


            i_Touch = 1;
            @(posedge i_Clk);
            i_Touch = 0;

            repeat(50) @(posedge i_Clk);


            i_Touch = 1;
            @(posedge i_Clk);
            i_Touch = 0;

            repeat(50) @(posedge i_Clk);


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
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_o_Light;
        begin
            if (expected_o_Light === (expected_o_Light ^ o_Light ^ expected_o_Light)) begin
                $display("PASS");
                $display("  Outputs: o_Light=%b",
                         o_Light);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_Light=%b",
                         expected_o_Light);
                $display("  Got:      o_Light=%b",
                         o_Light);
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
        $dumpvars(0,i_Clk, i_Touch, o_Light);
    end

endmodule
