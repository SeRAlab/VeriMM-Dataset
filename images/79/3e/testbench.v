`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] tied_also;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .tied_also(tied_also)
    );
    task testcase001;

        begin
            tied_also = 4'b0000;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase002;

        begin
            tied_also = 4'b0010;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            tied_also = 4'b0100;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase004;

        begin
            tied_also = 4'b0110;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase005;

        begin
            tied_also = 4'b1000;
            #1;

            check_outputs(4'b1001);
        end
        endtask

    task testcase006;

        begin
            tied_also = 4'b1001;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase007;

        begin
            tied_also = 4'b0101;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase008;

        begin
            tied_also = 4'b1111;
            #1;

            check_outputs(4'b1101);
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
        begin
            #1; // Small delay for combinational logic to settle
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

endmodule
