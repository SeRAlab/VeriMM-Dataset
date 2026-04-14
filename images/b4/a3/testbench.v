`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg GIN1;
    reg GIN2;
    reg PHI;
    reg PIN2;
    wire GOUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .GIN1(GIN1),
        .GIN2(GIN2),
        .PHI(PHI),
        .PIN2(PIN2),
        .GOUT(GOUT)
    );

    // Clock generation (10ns period)
    initial begin
        PHI = 0;
        forever #5 PHI = ~PHI;
    end

        task reset_dut;

        begin
            GIN1 = 0;
            GIN2 = 0;
            PIN2 = 0;
            @(posedge PHI);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            GIN1 = 0; GIN2 = 0; PIN2 = 0;
            @(posedge PHI);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            GIN1 = 1; GIN2 = 0; PIN2 = 1;
            @(posedge PHI);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            GIN1 = 0; GIN2 = 1; PIN2 = 1;
            @(posedge PHI);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            GIN1 = 1; GIN2 = 1; PIN2 = 0;
            @(posedge PHI);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            GIN1 = 1; GIN2 = 1; PIN2 = 1;
            @(posedge PHI);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            GIN1 = 0; GIN2 = 1; PIN2 = 0;
            @(posedge PHI);
            #2;
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
        input expected_GOUT;
        begin
            if (expected_GOUT === (expected_GOUT ^ GOUT ^ expected_GOUT)) begin
                $display("PASS");
                $display("  Outputs: GOUT=%b",
                         GOUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: GOUT=%b",
                         expected_GOUT);
                $display("  Got:      GOUT=%b",
                         GOUT);
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
        $dumpvars(0,GIN1, GIN2, PHI, PIN2, GOUT);
    end

endmodule
