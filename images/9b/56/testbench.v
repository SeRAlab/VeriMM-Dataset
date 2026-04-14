`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Z_B;
    reg n62;
    reg n63;
    wire Len_int;
    wire Ren_int;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Z_B(Z_B),
        .n62(n62),
        .n63(n63),
        .Len_int(Len_int),
        .Ren_int(Ren_int)
    );
    task testcase001;

    begin
        test_num = 1;
        n63 = 0; Z_B = 0; n62 = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        n63 = 0; Z_B = 0; n62 = 1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        n63 = 0; Z_B = 1; n62 = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        n63 = 0; Z_B = 1; n62 = 1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        n63 = 1; Z_B = 0; n62 = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        n63 = 1; Z_B = 0; n62 = 1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        n63 = 1; Z_B = 1; n62 = 0;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        n63 = 1; Z_B = 1; n62 = 1;
        #1;

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
        input expected_Len_int;
        input expected_Ren_int;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Len_int === (expected_Len_int ^ Len_int ^ expected_Len_int) &&
                expected_Ren_int === (expected_Ren_int ^ Ren_int ^ expected_Ren_int)) begin
                $display("PASS");
                $display("  Outputs: Len_int=%b, Ren_int=%b",
                         Len_int, Ren_int);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Len_int=%b, Ren_int=%b",
                         expected_Len_int, expected_Ren_int);
                $display("  Got:      Len_int=%b, Ren_int=%b",
                         Len_int, Ren_int);
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
