`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ALUT;
    reg BLUT;
    reg C0;
    wire Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUT(ALUT),
        .BLUT(BLUT),
        .C0(C0),
        .Z(Z)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: C0=0 (Select ALUT), ALUT=0, BLUT=0", test_num);
        ALUT = 1'b0; BLUT = 1'b0; C0 = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: C0=0 (Select ALUT), ALUT=1, BLUT=0", test_num);
        ALUT = 1'b1; BLUT = 1'b0; C0 = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: C0=0 (Select ALUT), ALUT=0, BLUT=1", test_num);
        ALUT = 1'b0; BLUT = 1'b1; C0 = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: C0=0 (Select ALUT), ALUT=1, BLUT=1", test_num);
        ALUT = 1'b1; BLUT = 1'b1; C0 = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: C0=1 (Select BLUT), ALUT=0, BLUT=0", test_num);
        ALUT = 1'b0; BLUT = 1'b0; C0 = 1'b1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: C0=1 (Select BLUT), ALUT=1, BLUT=0", test_num);
        ALUT = 1'b1; BLUT = 1'b0; C0 = 1'b1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: C0=1 (Select BLUT), ALUT=0, BLUT=1", test_num);
        ALUT = 1'b0; BLUT = 1'b1; C0 = 1'b1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: C0=1 (Select BLUT), ALUT=1, BLUT=1", test_num);
        ALUT = 1'b1; BLUT = 1'b1; C0 = 1'b1;
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
        input expected_Z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: Z=%b",
                         Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%b",
                         expected_Z);
                $display("  Got:      Z=%b",
                         Z);
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
