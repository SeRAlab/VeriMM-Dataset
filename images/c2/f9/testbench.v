`timescale 1ns/1ps

module tkg_c3_tb;

    // Testbench signals (combinational circuit)
    reg i0;
    reg i1;
    reg i2;
    wire o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tkg_c3 dut (
        .i0(i0),
        .i1(i1),
        .i2(i2),
        .o(o)
    );
    task testcase001;

    begin
        test_num = 1;
        i0 = 0; i1 = 0; i2 = 0;
        $display("Testcase %0d: Inputs: i0=0, i1=0, i2=0", test_num);
        #1;

        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        i0 = 0; i1 = 0; i2 = 1;
        $display("Testcase %0d: Inputs: i0=0, i1=0, i2=1", test_num);
        #1;

        check_outputs(0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        i0 = 0; i1 = 1; i2 = 0;
        $display("Testcase %0d: Inputs: i0=0, i1=1, i2=0", test_num);
        #1;

        check_outputs(0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        i0 = 0; i1 = 1; i2 = 1;
        $display("Testcase %0d: Inputs: i0=0, i1=1, i2=1 (Majority high)", test_num);
        #1;

        check_outputs(1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        i0 = 1; i1 = 0; i2 = 0;
        $display("Testcase %0d: Inputs: i0=1, i1=0, i2=0", test_num);
        #1;

        check_outputs(0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        i0 = 1; i1 = 0; i2 = 1;
        $display("Testcase %0d: Inputs: i0=1, i1=0, i2=1 (Majority high)", test_num);
        #1;

        check_outputs(1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        i0 = 1; i1 = 1; i2 = 0;
        $display("Testcase %0d: Inputs: i0=1, i1=1, i2=0 (Majority high)", test_num);
        #1;

        check_outputs(1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        i0 = 1; i1 = 1; i2 = 1;
        $display("Testcase %0d: Inputs: i0=1, i1=1, i2=1 (All high)", test_num);
        #1;

        check_outputs(1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("tkg_c3 Testbench");
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
        input expected_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o === (expected_o ^ o ^ expected_o)) begin
                $display("PASS");
                $display("  Outputs: o=%b",
                         o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o=%b",
                         expected_o);
                $display("  Got:      o=%b",
                         o);
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
