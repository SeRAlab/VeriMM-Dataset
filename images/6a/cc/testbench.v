`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CK;
    reg E;
    reg SE;
    wire ECK;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CK(CK),
        .E(E),
        .SE(SE),
        .ECK(ECK)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: All inputs low", test_num);
        E = 0;
        SE = 0;
        CK = 0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Clock high while gate disabled", test_num);
        E = 0;
        SE = 0;
        CK = 1;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Gate enabled by E, CK low", test_num);
        E = 1;
        SE = 0;
        CK = 0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Gate enabled by E, CK high", test_num);
        E = 1;
        SE = 0;
        CK = 1;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Gate enabled by SE, CK low", test_num);
        E = 0;
        SE = 1;
        CK = 0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Gate enabled by SE, CK high", test_num);
        E = 0;
        SE = 1;
        CK = 1;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Gate enabled by both, CK low", test_num);
        E = 1;
        SE = 1;
        CK = 0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Gate enabled by both, CK high", test_num);
        E = 1;
        SE = 1;
        CK = 1;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Transition E low to high while CK is low", test_num);
        CK = 0; SE = 0; E = 0;
        #5;
        E = 1;
        #5;
        CK = 1;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Transition SE high while CK is high", test_num);
        CK = 1; E = 0; SE = 0;
        #10;
        SE = 1;
        #10;



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
        input expected_ECK;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ECK === (expected_ECK ^ ECK ^ expected_ECK)) begin
                $display("PASS");
                $display("  Outputs: ECK=%b",
                         ECK);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ECK=%b",
                         expected_ECK);
                $display("  Got:      ECK=%b",
                         ECK);
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
