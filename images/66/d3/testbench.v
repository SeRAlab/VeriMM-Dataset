`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] adr;
    reg [7:0] db;
    reg load_adr;
    reg load_db;
    reg load_not_db;
    reg [7:0] not_db;
    wire [7:0] b_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .adr(adr),
        .db(db),
        .load_adr(load_adr),
        .load_db(load_db),
        .load_not_db(load_not_db),
        .not_db(not_db),
        .b_out(b_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Loading not_db", test_num);
            load_not_db = 1'b1;
            load_db     = 1'b0;
            load_adr    = 1'b0;
            not_db      = 8'hA5;
            db          = 8'h00;
            adr         = 8'h00;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Loading db", test_num);
            load_not_db = 1'b0;
            load_db     = 1'b1;
            load_adr    = 1'b0;
            not_db      = 8'h00;
            db          = 8'h5A;
            adr         = 8'h00;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Loading adr", test_num);
            load_not_db = 1'b0;
            load_db     = 1'b0;
            load_adr    = 1'b1;
            not_db      = 8'h00;
            db          = 8'h00;
            adr         = 8'hFF;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Loading not_db with different value", test_num);
            load_not_db = 1'b1;
            load_db     = 1'b0;
            load_adr    = 1'b0;
            not_db      = 8'h3C;
            db          = 8'hFF;
            adr         = 8'hAA;
            #1;

            check_outputs(8'h3C);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Loading db with different value", test_num);
            load_not_db = 1'b0;
            load_db     = 1'b1;
            load_adr    = 1'b0;
            not_db      = 8'h12;
            db          = 8'hC3;
            adr         = 8'h34;
            #1;

            check_outputs(8'hC3);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Loading adr with different value", test_num);
            load_not_db = 1'b0;
            load_db     = 1'b0;
            load_adr    = 1'b1;
            not_db      = 8'h77;
            db          = 8'h88;
            adr         = 8'h99;
            #1;

            check_outputs(8'h99);
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
        input [7:0] expected_b_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_b_out === (expected_b_out ^ b_out ^ expected_b_out)) begin
                $display("PASS");
                $display("  Outputs: b_out=%h",
                         b_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: b_out=%h",
                         expected_b_out);
                $display("  Got:      b_out=%h",
                         b_out);
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
