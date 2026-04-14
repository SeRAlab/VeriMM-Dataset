`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clock;
    reg Data0;
    reg Enable;
    wire Q0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clock(Clock),
        .Data0(Data0),
        .Enable(Enable),
        .Q0(Q0)
    );

    // Clock generation (10ns period)
    initial begin
        Clock = 0;
        forever #5 Clock = ~Clock;
    end

        task reset_dut;

        begin



            @(negedge Clock);
            Enable = 1;
            Data0 = 0;
            @(posedge Clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Write 1 with Enable high", test_num);
            reset_dut();

            @(negedge Clock);
            Enable = 1;
            Data0 = 1;
            @(posedge Clock);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Attempt to write 1 with Enable low (Hold 0)", test_num);
            reset_dut();

            @(negedge Clock);
            Enable = 0;
            Data0 = 1;
            @(posedge Clock);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Attempt to write 0 with Enable low (Hold 1)", test_num);
            reset_dut();


            @(negedge Clock);
            Enable = 1;
            Data0 = 1;
            @(posedge Clock);
            #1;


            @(negedge Clock);
            Enable = 0;
            Data0 = 0;
            @(posedge Clock);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Write 0 with Enable high", test_num);
            reset_dut();


            @(negedge Clock);
            Enable = 1;
            Data0 = 1;
            @(posedge Clock);
            #1;


            @(negedge Clock);
            Enable = 1;
            Data0 = 0;
            @(posedge Clock);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data changes on falling edge (No change)", test_num);
            reset_dut();

            @(negedge Clock);
            Enable = 1;
            Data0 = 1;
            @(posedge Clock);
            #1;

            @(negedge Clock);
            Data0 = 0;
            #1;


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple cycles with Enable low", test_num);
            reset_dut();


            @(negedge Clock);
            Enable = 1;
            Data0 = 1;
            @(posedge Clock);
            #1;


            Enable = 0;
            repeat(3) begin
                @(negedge Clock);
                Data0 = ~Data0;
                @(posedge Clock);
                #1;
            end

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
        input expected_Q0;
        begin
            if (expected_Q0 === (expected_Q0 ^ Q0 ^ expected_Q0)) begin
                $display("PASS");
                $display("  Outputs: Q0=%b",
                         Q0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q0=%b",
                         expected_Q0);
                $display("  Got:      Q0=%b",
                         Q0);
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
        $dumpvars(0,Clock, Data0, Enable, Q0);
    end

endmodule
