`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Gant;
    reg Gloc;
    reg Pant;
    reg Ploc;
    wire Gsal;
    wire Psal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Gant(Gant),
        .Gloc(Gloc),
        .Pant(Pant),
        .Ploc(Ploc),
        .Gsal(Gsal),
        .Psal(Psal)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs zero", test_num);
            Ploc = 0; Pant = 0; Gloc = 0; Gant = 0;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Psal high (Ploc & Pant), Gsal low", test_num);
            Ploc = 1; Pant = 1; Gloc = 0; Gant = 0;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Gsal high via Gloc", test_num);
            Ploc = 0; Pant = 0; Gloc = 1; Gant = 0;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Gsal high via (Ploc & Gant)", test_num);
            Ploc = 1; Pant = 0; Gloc = 0; Gant = 1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Both Psal and Gsal high (All high)", test_num);
            Ploc = 1; Pant = 1; Gloc = 1; Gant = 1;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Gsal high via Gloc, Psal low via Pant=0", test_num);
            Ploc = 1; Pant = 0; Gloc = 1; Gant = 0;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Ploc=0, checking logic isolation", test_num);
            Ploc = 0; Pant = 1; Gloc = 0; Gant = 1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Psal high, Gsal high via Ploc & Gant", test_num);
            Ploc = 1; Pant = 1; Gloc = 0; Gant = 1;
            #1;

            check_outputs(1, 1);
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
        input expected_Gsal;
        input expected_Psal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Gsal === (expected_Gsal ^ Gsal ^ expected_Gsal) &&
                expected_Psal === (expected_Psal ^ Psal ^ expected_Psal)) begin
                $display("PASS");
                $display("  Outputs: Gsal=%b, Psal=%b",
                         Gsal, Psal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Gsal=%b, Psal=%b",
                         expected_Gsal, expected_Psal);
                $display("  Got:      Gsal=%b, Psal=%b",
                         Gsal, Psal);
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
