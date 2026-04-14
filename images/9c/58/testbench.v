`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] address_0;
    reg [7:0] address_1;
    reg cs_0;
    reg cs_1;
    reg oe_0;
    reg oe_1;
    reg we_0;
    reg we_1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address_0(address_0),
        .address_1(address_1),
        .cs_0(cs_0),
        .cs_1(cs_1),
        .oe_0(oe_0),
        .oe_1(oe_1),
        .we_0(we_0),
        .we_1(we_1)
    );
    task testcase001;

        begin
            test_num = test_num + 1;

            address_0 = 8'h0A;
            data_0_out = 8'h55;
            drive_0 = 1; we_0 = 1; cs_0 = 1; oe_0 = 0;
            #10;

            drive_0 = 0; we_0 = 0; cs_0 = 1; oe_0 = 1;
            #10;
            #1;

            check_outputs(8'h55, 8'hzz);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;

            address_1 = 8'hF0;
            data_1_out = 8'hAA;
            drive_1 = 1; we_1 = 1; cs_1 = 1; oe_1 = 0;
            #10;

            drive_1 = 0; we_1 = 0; cs_1 = 1; oe_1 = 1;
            #10;
            #1;

            check_outputs(8'hzz, 8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;

            address_0 = 8'h20;
            data_0_out = 8'hBE;
            drive_0 = 1; we_0 = 1; cs_0 = 1; oe_0 = 0;
            #10;
            drive_0 = 0; we_0 = 0;

            address_1 = 8'h20;
            drive_1 = 0; we_1 = 0; cs_1 = 1; oe_1 = 1;
            #10;
            #1;

            check_outputs(8'hzz, 8'hBE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;

            address_0 = 8'h30; data_0_out = 8'hCC; drive_0 = 1; we_0 = 1; cs_0 = 1; oe_0 = 0;
            #10;

            drive_0 = 0; we_0 = 0; cs_0 = 0; oe_0 = 1;
            #10;
            #1;

            check_outputs(8'hzz, 8'hzz);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;

            address_0 = 8'h30; drive_0 = 0; we_0 = 0; cs_0 = 1; oe_0 = 0;
            #10;
            #1;

            check_outputs(8'hzz, 8'hzz);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;

            address_0 = 8'h40; data_0_out = 8'h11; drive_0 = 1; we_0 = 1; cs_0 = 1; oe_0 = 0;
            address_1 = 8'h41; data_1_out = 8'h22; drive_1 = 1; we_1 = 1; cs_1 = 1; oe_1 = 0;
            #10;

            drive_0 = 0; we_0 = 0; oe_0 = 1;
            drive_1 = 0; we_1 = 0; oe_1 = 1;
            #10;
            #1;

            check_outputs(8'h11, 8'h22);
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
