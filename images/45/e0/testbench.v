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
            reset = 0;
            enable = 0;
            up_en = 0;
            down_en = 0;
            @(posedge clk);
            #1;
            reset = 1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            enable = 1;
            up_en = 1;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            enable = 1;
            up_en = 1;
            repeat (5) @(posedge clk);

            up_en = 0;
            down_en = 1;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            enable = 1;
            up_en = 1;
            repeat (3) @(posedge clk);
            enable = 0;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            enable = 1;
            up_en = 1;
            repeat (16) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            enable = 1;
            down_en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            enable = 1;
            up_en = 1;
            down_en = 1;
            repeat (4) @(posedge clk);
            #1;

            if (q >= 0 && q <= 15) begin
                $display("Test 007 (Conflict) yielded q = %d", q);
                pass_count = pass_count + 1;
                test_num = test_num + 1;
            end else begin
                fail_count = fail_count + 1;
                test_num = test_num + 1;
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
