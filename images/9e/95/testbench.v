`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg c;
    reg select;
    wire w;
    wire x;
    wire y;
    wire z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .select(select),
        .w(w),
        .x(x),
        .y(y),
        .z(z)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: All inputs zero, select zero", test_num);
        a = 0; b = 0; c = 0; select = 0;
        #1;

        check_outputs(0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: a=1, others 0, select zero", test_num);
        a = 1; b = 0; c = 0; select = 0;
        #1;

        check_outputs(1, 0, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: b=1, others 0, select zero", test_num);
        a = 0; b = 1; c = 0; select = 0;
        #1;

        check_outputs(0, 1, 1, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: c=1, others 0, select zero", test_num);
        a = 0; b = 0; c = 1; select = 0;
        #1;

        check_outputs(0, 0, 0, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: select switches to c, c=1", test_num);
        a = 0; b = 0; c = 1; select = 1;
        #1;

        check_outputs(0, 1, 1, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: select=1, b=1, c=0", test_num);
        a = 0; b = 1; c = 0; select = 1;
        #1;

        check_outputs(0, 0, 0, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: All inputs one, select one", test_num);
        a = 1; b = 1; c = 1; select = 1;
        #1;

        check_outputs(1, 1, 1, 1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: a=1, b=1, c=0, select=0", test_num);
        a = 1; b = 1; c = 0; select = 0;
        #1;

        check_outputs(1, 1, 1, 0);
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
        input expected_w;
        input expected_x;
        input expected_y;
        input expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_w === (expected_w ^ w ^ expected_w) &&
                expected_x === (expected_x ^ x ^ expected_x) &&
                expected_y === (expected_y ^ y ^ expected_y) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: w=%b, x=%b, y=%b, z=%b",
                         w, x, y, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: w=%b, x=%b, y=%b, z=%b",
                         expected_w, expected_x, expected_y, expected_z);
                $display("  Got:      w=%b, x=%b, y=%b, z=%b",
                         w, x, y, z);
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
