`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] address;
    reg is_sector1_writable;
    reg is_sector2_writable;
    reg is_sector3_writable;
    reg is_sector4_writable;
    reg is_sector5_writable;
    wire is_addr_writable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .is_sector1_writable(is_sector1_writable),
        .is_sector2_writable(is_sector2_writable),
        .is_sector3_writable(is_sector3_writable),
        .is_sector4_writable(is_sector4_writable),
        .is_sector5_writable(is_sector5_writable),
        .is_addr_writable(is_addr_writable)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Address 1, Sector 1 is writable", test_num);
            address = 3'd1;
            is_sector1_writable = 1'b1;
            is_sector2_writable = 1'b0;
            is_sector3_writable = 1'b0;
            is_sector4_writable = 1'b0;
            is_sector5_writable = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Address 1, Sector 1 is NOT writable", test_num);
            address = 3'd1;
            is_sector1_writable = 1'b0;
            is_sector2_writable = 1'b1;
            is_sector3_writable = 1'b1;
            is_sector4_writable = 1'b1;
            is_sector5_writable = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Address 2, Sector 2 is writable", test_num);
            address = 3'd2;
            is_sector1_writable = 1'b0;
            is_sector2_writable = 1'b1;
            is_sector3_writable = 1'b0;
            is_sector4_writable = 1'b0;
            is_sector5_writable = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Address 3, Sector 3 is writable", test_num);
            address = 3'd3;
            is_sector1_writable = 1'b1;
            is_sector2_writable = 1'b1;
            is_sector3_writable = 1'b1;
            is_sector4_writable = 1'b1;
            is_sector5_writable = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Address 4, Sector 4 is writable", test_num);
            address = 3'd4;
            is_sector1_writable = 1'b0;
            is_sector2_writable = 1'b0;
            is_sector3_writable = 1'b0;
            is_sector4_writable = 1'b1;
            is_sector5_writable = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Address 5, Sector 5 is writable", test_num);
            address = 3'd5;
            is_sector1_writable = 1'b0;
            is_sector2_writable = 1'b0;
            is_sector3_writable = 1'b0;
            is_sector4_writable = 1'b0;
            is_sector5_writable = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Address 0 (Invalid Sector), All sectors writable", test_num);
            address = 3'd0;
            is_sector1_writable = 1'b1;
            is_sector2_writable = 1'b1;
            is_sector3_writable = 1'b1;
            is_sector4_writable = 1'b1;
            is_sector5_writable = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Address 6 (Invalid Sector), All sectors writable", test_num);
            address = 3'd6;
            is_sector1_writable = 1'b1;
            is_sector2_writable = 1'b1;
            is_sector3_writable = 1'b1;
            is_sector4_writable = 1'b1;
            is_sector5_writable = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Address 7 (Invalid Sector), All sectors writable", test_num);
            address = 3'd7;
            is_sector1_writable = 1'b1;
            is_sector2_writable = 1'b1;
            is_sector3_writable = 1'b1;
            is_sector4_writable = 1'b1;
            is_sector5_writable = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Address 3, Sector 3 NOT writable, but others are", test_num);
            address = 3'd3;
            is_sector1_writable = 1'b1;
            is_sector2_writable = 1'b1;
            is_sector3_writable = 1'b0;
            is_sector4_writable = 1'b1;
            is_sector5_writable = 1'b1;
            #1;

            check_outputs(1'b0);
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
        testcase009();
        testcase010();
        
        
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
        input expected_is_addr_writable;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_is_addr_writable === (expected_is_addr_writable ^ is_addr_writable ^ expected_is_addr_writable)) begin
                $display("PASS");
                $display("  Outputs: is_addr_writable=%b",
                         is_addr_writable);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: is_addr_writable=%b",
                         expected_is_addr_writable);
                $display("  Got:      is_addr_writable=%b",
                         is_addr_writable);
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
