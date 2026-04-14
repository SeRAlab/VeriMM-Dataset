`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg p;
    reg q;
    reg r;
    reg s;
    wire i_pos;
    wire i_sop;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .p(p),
        .q(q),
        .r(r),
        .s(s),
        .i_pos(i_pos),
        .i_sop(i_sop)
    );
    task testcase001;

    begin

        p = 0; q = 0; r = 0; s = 0;
        #10; #1;
 check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin

        p = 0; q = 0; r = 0; s = 1;
        #10; #1;
 check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin

        p = 0; q = 0; r = 1; s = 0;
        #10; #1;
 check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin

        p = 0; q = 0; r = 1; s = 1;
        #10; #1;
 check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin

        p = 0; q = 1; r = 0; s = 0;
        #10; #1;
 check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin

        p = 0; q = 1; r = 0; s = 1;
        #10; #1;
 check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin

        p = 0; q = 1; r = 1; s = 0;
        #10; #1;
 check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin

        p = 0; q = 1; r = 1; s = 1;
        #10; #1;
 check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase009;

    begin

        p = 1; q = 0; r = 0; s = 0;
        #10; #1;
 check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase010;

    begin

        p = 1; q = 0; r = 0; s = 1;
        #10; #1;
 check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase011;

    begin

        p = 1; q = 0; r = 1; s = 0;
        #10; #1;
 check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase012;

    begin

        p = 1; q = 0; r = 1; s = 1;
        #10; #1;
 check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase013;

    begin

        p = 1; q = 1; r = 0; s = 0;
        #10; #1;
 check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase014;

    begin

        p = 1; q = 1; r = 0; s = 1;
        #10; #1;
 check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase015;

    begin

        p = 1; q = 1; r = 1; s = 0;
        #10; #1;
 check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase016;

    begin

        p = 1; q = 1; r = 1; s = 1;
        #10; #1;
 check_outputs(1'b1, 1'b1);
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
        testcase016();
        
        
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
        input expected_i_pos;
        input expected_i_sop;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_i_pos === (expected_i_pos ^ i_pos ^ expected_i_pos) &&
                expected_i_sop === (expected_i_sop ^ i_sop ^ expected_i_sop)) begin
                $display("PASS");
                $display("  Outputs: i_pos=%b, i_sop=%b",
                         i_pos, i_sop);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: i_pos=%b, i_sop=%b",
                         expected_i_pos, expected_i_sop);
                $display("  Got:      i_pos=%b, i_sop=%b",
                         i_pos, i_sop);
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
