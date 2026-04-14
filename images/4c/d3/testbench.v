`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg cZero;
    reg gOne;
    reg gThree;
    reg gTwo;
    reg gZero;
    reg pOne;
    reg pThree;
    reg pTwo;
    reg pZero;
    wire cThirtyTwo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cZero(cZero),
        .gOne(gOne),
        .gThree(gThree),
        .gTwo(gTwo),
        .gZero(gZero),
        .pOne(pOne),
        .pThree(pThree),
        .pTwo(pTwo),
        .pZero(pZero),
        .cThirtyTwo(cThirtyTwo)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: All inputs zero", test_num);
        gZero = 0; pZero = 0; cZero = 0;
        gOne = 0; pOne = 0;
        gTwo = 0; pTwo = 0;
        gThree = 0; pThree = 0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: All inputs high (testing fixed LOW output)", test_num);
        gZero = 1; pZero = 1; cZero = 1;
        gOne = 1; pOne = 1;
        gTwo = 1; pTwo = 1;
        gThree = 1; pThree = 1;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Carry generated at bit 3", test_num);
        gZero = 0; pZero = 0; cZero = 0;
        gOne = 0; pOne = 0;
        gTwo = 0; pTwo = 0;
        gThree = 1; pThree = 1;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Carry propagation from cZero", test_num);
        gZero = 0; pZero = 1; cZero = 1;
        gOne = 0; pOne = 1;
        gTwo = 0; pTwo = 1;
        gThree = 0; pThree = 1;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Partial generate/propagate conditions", test_num);
        gZero = 1; pZero = 0; cZero = 1;
        gOne = 0; pOne = 0;
        gTwo = 1; pTwo = 1;
        gThree = 0; pThree = 1;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Toggle cZero only", test_num);
        gZero = 0; pZero = 0; cZero = 1;
        gOne = 0; pOne = 0;
        gTwo = 0; pTwo = 0;
        gThree = 0; pThree = 0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Bit 2 generate and Bit 3 propagate", test_num);
        gZero = 0; pZero = 0; cZero = 0;
        gOne = 0; pOne = 0;
        gTwo = 1; pTwo = 0;
        gThree = 0; pThree = 1;
        #10;
        #1;

        check_outputs(1'b0);
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
        input expected_cThirtyTwo;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cThirtyTwo === (expected_cThirtyTwo ^ cThirtyTwo ^ expected_cThirtyTwo)) begin
                $display("PASS");
                $display("  Outputs: cThirtyTwo=%b",
                         cThirtyTwo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cThirtyTwo=%b",
                         expected_cThirtyTwo);
                $display("  Got:      cThirtyTwo=%b",
                         cThirtyTwo);
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
