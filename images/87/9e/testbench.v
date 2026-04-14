`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg inv;
    reg [127:0] shftIn;
    wire [127:0] shftOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inv(inv),
        .shftIn(shftIn),
        .shftOut(shftOut)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Forward ShiftRows (inv=0)", test_num);
        inv = 1'b0;

        shftIn = 128'h000102030405060708090a0b0c0d0e0f;

        #1;


        check_outputs(128'h00050a0f04090e03080d02070c01060b);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Inverse ShiftRows (inv=1)", test_num);
        inv = 1'b1;

        shftIn = 128'h000102030405060708090a0b0c0d0e0f;

        #1;


        check_outputs(128'h000d0a0704010e0b0805020f0c090603);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Reversibility Check (Inv(Shift(X)) == X)", test_num);
        inv = 1'b1;

        shftIn = 128'h00050a0f04090e03080d02070c01060b;

        #1;


        check_outputs(128'h000102030405060708090a0b0c0d0e0f);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: All Zeros Identity", test_num);
        inv = 1'b0;
        shftIn = 128'h0;
        #1;

        check_outputs(128'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: All Ones Identity", test_num);
        inv = 1'b1;
        shftIn = {128{1'b1}};
        #1;

        check_outputs({128{1'b1}});
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Custom Pattern Encryption", test_num);
        inv = 1'b0;

        shftIn = 128'hfedcba98765432100123456789abcdef;




        #1;





        check_outputs(128'hfe5445ef7623cd9801abba1089dc3267);
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
        input [127:0] expected_shftOut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_shftOut === (expected_shftOut ^ shftOut ^ expected_shftOut)) begin
                $display("PASS");
                $display("  Outputs: shftOut=%h",
                         shftOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shftOut=%h",
                         expected_shftOut);
                $display("  Got:      shftOut=%h",
                         shftOut);
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
