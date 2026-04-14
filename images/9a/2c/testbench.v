`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] db;
    reg ptype;
    wire error;
    wire pbit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .db(db),
        .ptype(ptype),
        .error(error),
        .pbit(pbit)
    );
    task testcase001;

    begin
        test_num = 1;
        db = 8'b00000000;
        ptype = 0;

        #1;


        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        db = 8'b00000000;
        ptype = 1;

        #1;


        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        db = 8'b00000001;
        ptype = 0;

        #1;


        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        db = 8'b00000001;
        ptype = 1;

        #1;


        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        db = 8'b00000011;
        ptype = 0;

        #1;


        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        db = 8'b00000011;
        ptype = 1;

        #1;


        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        db = 8'b11111111;
        ptype = 0;

        #1;


        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        db = 8'b11111111;
        ptype = 1;

        #1;


        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        db = 8'b10110110;
        ptype = 0;

        #1;


        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        db = 8'b10110110;
        ptype = 1;

        #1;


        check_outputs(1'b0, 1'b0);
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
        input expected_error;
        input expected_pbit;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_error === (expected_error ^ error ^ expected_error) &&
                expected_pbit === (expected_pbit ^ pbit ^ expected_pbit)) begin
                $display("PASS");
                $display("  Outputs: error=%b, pbit=%b",
                         error, pbit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: error=%b, pbit=%b",
                         expected_error, expected_pbit);
                $display("  Got:      error=%b, pbit=%b",
                         error, pbit);
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
