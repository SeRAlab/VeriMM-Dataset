`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg dir;
    reg g;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dir(dir),
        .g(g)
    );
    task testcase001;

        begin
            test_num = 1;
            g = 1'b1;
            dir = 1'b0;
            a_drv = 1'b0;
            b_drv = 1'b0;
            #1;

            check_outputs(8'bz, 8'bz);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            g = 1'b0;
            dir = 1'b1;
            a_drv = 1'b1;
            a_in = 8'hA5;
            b_drv = 1'b0;
            #1;

            check_outputs(8'hA5, 8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            g = 1'b0;
            dir = 1'b0;
            a_drv = 1'b0;
            b_drv = 1'b1;
            b_in = 8'h5A;
            #1;

            check_outputs(8'h5A, 8'h5A);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            g = 1'b0;
            dir = 1'b1;
            a_drv = 1'b1;
            a_in = 8'h00;
            b_drv = 1'b0;
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            g = 1'b0;
            dir = 1'b0;
            a_drv = 1'b0;
            b_drv = 1'b1;
            b_in = 8'hFF;
            #1;

            check_outputs(8'hFF, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            g = 1'b1;
            dir = 1'b1;
            a_drv = 1'b1;
            a_in = 8'hCC;
            b_drv = 1'b0;

            #1;


            check_outputs(8'hCC, 8'bz);
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
