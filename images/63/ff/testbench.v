`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] pri;
    reg [3:0] req;
    wire sel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pri(pri),
        .req(req),
        .sel(sel)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: No requests active", test_num);
        req = 4'b0000;
        pri = 4'b0000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Only Request 0 active (pri=0)", test_num);
        req = 4'b0001;
        pri = 4'b0000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Only Request 1 active (Req 0 should be 0)", test_num);
        req = 4'b0010;
        pri = 4'b0000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Req 0 and 1 active, same priority (Tie-break favors 0)", test_num);
        req = 4'b0011;
        pri = 4'b0000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Req 1 has higher priority than Req 0", test_num);
        req = 4'b0011;
        pri = 4'b0010;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Req 0 has higher priority than Req 1", test_num);
        req = 4'b0011;
        pri = 4'b0001;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Req 0 and 3 high pri (Tie-break favors 0)", test_num);
        req = 4'b1001;
        pri = 4'b1001;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %03d: All active, Req 2 is only high priority", test_num);
        req = 4'b1111;
        pri = 4'b0100;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %03d: All active, all same priority (Smallest index 0 wins)", test_num);
        req = 4'b1111;
        pri = 4'b1111;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %010: Req 0 high pri, others low pri", test_num);
        req = 4'b1111;
        pri = 4'b0001;
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
        input expected_sel;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sel === (expected_sel ^ sel ^ expected_sel)) begin
                $display("PASS");
                $display("  Outputs: sel=%b",
                         sel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sel=%b",
                         expected_sel);
                $display("  Got:      sel=%b",
                         sel);
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
