`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (

    );

        task reset_dut;

        begin
            D = 0;
            SET = 0;
            KAPWR = 1;
            SLEEP_B = 1;
            VPWR = 1;
            VGND = 0;
            #15;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            D = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            D = 1;
            @(posedge CLK);
            #2;

            D = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            D = 0;
            @(posedge CLK);
            #2;
            SET = 1;
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            D = 1;
            @(posedge CLK);
            #2;

            SLEEP_B = 0;
            #5;

            D = 0;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            KAPWR = 0;
            D = 1;
            @(posedge CLK);
            #2;


            if (Q !== 1'b1) begin
                pass_count = pass_count + 1;
                $display("testcase005: PASS (Output correctly not 1 when powered down)");
            end else begin
                fail_count = fail_count + 1;
                $display("testcase005: FAIL (Output captured value despite KAPWR=0)");
            end
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            VPWR = 0;
            #5;

            if (Q === 1'bx || Q === 1'b0) begin
                pass_count = pass_count + 1;
                $display("testcase006: PASS (Power cut correctly affected output)");
            end else begin
                fail_count = fail_count + 1;
                $display("testcase006: FAIL (Output stayed high with VPWR=0)");
            end
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
        begin
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
        $dumpvars(0,);
    end

endmodule
