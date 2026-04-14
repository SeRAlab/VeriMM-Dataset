`timescale 1ns/1ps

module power_gating_tb;

    // Testbench signals (combinational circuit)
    reg ctrl1;
    reg ctrl2;
    reg in;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    power_gating dut (
        .ctrl1(ctrl1),
        .ctrl2(ctrl2),
        .in(in),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: All signals High (ctrl1=1, ctrl2=1, in=1)", test_num);
        ctrl1 = 1;
        ctrl2 = 1;
        in = 1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Controls High, Input Low (ctrl1=1, ctrl2=1, in=0)", test_num);
        ctrl1 = 1;
        ctrl2 = 1;
        in = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: ctrl1 Low, others High (ctrl1=0, ctrl2=1, in=1)", test_num);
        ctrl1 = 0;
        ctrl2 = 1;
        in = 1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: ctrl2 Low, others High (ctrl1=1, ctrl2=0, in=1)", test_num);
        ctrl1 = 1;
        ctrl2 = 0;
        in = 1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Both controls Low, Input High (ctrl1=0, ctrl2=0, in=1)", test_num);
        ctrl1 = 0;
        ctrl2 = 0;
        in = 1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: All signals Low (ctrl1=0, ctrl2=0, in=0)", test_num);
        ctrl1 = 0;
        ctrl2 = 0;
        in = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: ctrl1 toggles while others High", test_num);
        ctrl1 = 0; ctrl2 = 1; in = 1;
        #5;
        ctrl1 = 1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Input toggles while controls High", test_num);
        ctrl1 = 1; ctrl2 = 1; in = 1;
        #5;
        in = 0;
        #1;

        check_outputs(0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("power_gating Testbench");
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
                         out);
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
