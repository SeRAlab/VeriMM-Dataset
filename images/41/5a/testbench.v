`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] DBx;
    reg EN;
    wire DBP;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DBx(DBx),
        .EN(EN),
        .DBP(DBP)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: EN=0, DBx=8'h00 (Disable state check)", test_num);
        EN = 1'b0;
        DBx = 8'h00;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: EN=0, DBx=8'hFF (Disable state check with all high bits)", test_num);
        EN = 1'b0;
        DBx = 8'hFF;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: EN=0, DBx=8'h01 (Disable state check with odd bits)", test_num);
        EN = 1'b0;
        DBx = 8'h01;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: EN=1, DBx=8'h00 (Enable, 0 high bits - Even)", test_num);
        EN = 1'b1;
        DBx = 8'h00;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: EN=1, DBx=8'h01 (Enable, 1 high bit - Odd)", test_num);
        EN = 1'b1;
        DBx = 8'h01;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: EN=1, DBx=8'h03 (Enable, 2 high bits - Even)", test_num);
        EN = 1'b1;
        DBx = 8'h03;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: EN=1, DBx=8'h07 (Enable, 3 high bits - Odd)", test_num);
        EN = 1'b1;
        DBx = 8'h07;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: EN=1, DBx=8'h0F (Enable, 4 high bits - Even)", test_num);
        EN = 1'b1;
        DBx = 8'h0F;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: EN=1, DBx=8'h1F (Enable, 5 high bits - Odd)", test_num);
        EN = 1'b1;
        DBx = 8'h1F;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: EN=1, DBx=8'h3F (Enable, 6 high bits - Even)", test_num);
        EN = 1'b1;
        DBx = 8'h3F;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test %0d: EN=1, DBx=8'h7F (Enable, 7 high bits - Odd)", test_num);
        EN = 1'b1;
        DBx = 8'h7F;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test %0d: EN=1, DBx=8'hFF (Enable, 8 high bits - Even)", test_num);
        EN = 1'b1;
        DBx = 8'hFF;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        $display("Test %0d: EN=1, DBx=8'hAA (Enable, alternating pattern 10101010 - 4 bits, Even)", test_num);
        EN = 1'b1;
        DBx = 8'hAA;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase014;

    begin
        test_num = test_num + 1;
        $display("Test %0d: EN=1, DBx=8'h55 (Enable, alternating pattern 01010101 - 4 bits, Even)", test_num);
        EN = 1'b1;
        DBx = 8'h55;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase015;

    begin
        test_num = test_num + 1;
        $display("Test %0d: EN=1, DBx=8'h80 (Enable, single high bit - Odd)", test_num);
        EN = 1'b1;
        DBx = 8'h80;
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
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        
        
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
        input expected_DBP;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_DBP === (expected_DBP ^ DBP ^ expected_DBP)) begin
                $display("PASS");
                $display("  Outputs: DBP=%b",
                         DBP);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DBP=%b",
                         expected_DBP);
                $display("  Got:      DBP=%b",
                         DBP);
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
