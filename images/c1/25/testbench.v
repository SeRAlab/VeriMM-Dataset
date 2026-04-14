`timescale 1ns/1ps

module data_switch_mask_tb;

    // Testbench signals (combinational circuit)
    reg sw_down_en;
    reg sw_mask543_en;
    reg sw_up_en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_switch_mask dut (
        .sw_down_en(sw_down_en),
        .sw_mask543_en(sw_mask543_en),
        .sw_up_en(sw_up_en)
    );
    task testcase001;

        begin
            test_num = 1;
            sw_up_en = 0;
            sw_down_en = 0;
            sw_mask543_en = 0;

            db_down_drv = 8'hAA;
            db_up_drv = 8'h55;
            #1;

            check_outputs(8'hAA, 8'h55);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            sw_up_en = 1;
            sw_down_en = 0;
            sw_mask543_en = 0;
            db_down_drv = 8'hA5;
            db_up_drv = 8'bz;
            #1;

            check_outputs(8'hA5, 8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            sw_up_en = 0;
            sw_down_en = 1;
            sw_mask543_en = 0;
            db_up_drv = 8'hF0;
            db_down_drv = 8'bz;
            #1;

            check_outputs(8'hF0, 8'hF0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            sw_up_en = 0;
            sw_down_en = 1;
            sw_mask543_en = 1;
            db_up_drv = 8'hFF;
            db_down_drv = 8'bz;

            #1;


            check_outputs(8'b11zzz111, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            sw_up_en = 1;
            sw_down_en = 0;
            sw_mask543_en = 1;
            db_down_drv = 8'h3C;
            db_up_drv = 8'bz;
            #1;

            check_outputs(8'h3C, 8'h3C);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("data_switch_mask Testbench");
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
