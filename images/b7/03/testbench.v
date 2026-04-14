`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg cin;
    reg w;
    reg x;
    reg y;
    reg z;
    wire C;
    wire S;
    wire cout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cin(cin),
        .w(w),
        .x(x),
        .y(y),
        .z(z),
        .C(C),
        .S(S),
        .cout(cout)
    );
    task testcase001;

    begin
        test_num = 1;
        w = 0; x = 0; y = 0; z = 0; cin = 0;
        #1;

        check_outputs(0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        w = 1; x = 0; y = 0; z = 0; cin = 0;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        w = 1; x = 1; y = 0; z = 0; cin = 0;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        w = 1; x = 1; y = 1; z = 0; cin = 0;
        #1;

        check_outputs(0, 1, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        w = 1; x = 1; y = 1; z = 1; cin = 0;
        #1;

        check_outputs(1, 0, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        w = 1; x = 1; y = 1; z = 1; cin = 1;
        #1;

        check_outputs(1, 1, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        w = 0; x = 0; y = 0; z = 0; cin = 1;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        w = 0; x = 0; y = 1; z = 1; cin = 0;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        w = 0; x = 0; y = 1; z = 1; cin = 1;
        #1;

        check_outputs(1, 1, 0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        w = 1; x = 0; y = 1; z = 1; cin = 0;
        #1;

        check_outputs(0, 1, 1);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        w = 1; x = 0; y = 0; z = 1; cin = 1;
        #1;

        check_outputs(1, 1, 0);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        w = 0; x = 1; y = 1; z = 0; cin = 1;
        #1;

        check_outputs(0, 1, 1);
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
        input expected_C;
        input expected_S;
        input expected_cout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_S === (expected_S ^ S ^ expected_S) &&
                expected_cout === (expected_cout ^ cout ^ expected_cout)) begin
                $display("PASS");
                $display("  Outputs: C=%b, S=%b, cout=%b",
                         C, S, cout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%b, S=%b, cout=%b",
                         expected_C, expected_S, expected_cout);
                $display("  Got:      C=%b, S=%b, cout=%b",
                         C, S, cout);
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
