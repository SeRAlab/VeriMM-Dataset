`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] D0;
    reg [7:0] D1;
    reg ctrl;
    wire [7:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D0(D0),
        .D1(D1),
        .ctrl(ctrl),
        .S(S)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Select D0 (ctrl=0)", test_num);
        ctrl = 0;
        D0 = 8'hA5;
        D1 = 8'h5A;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Select D1 (ctrl=1)", test_num);
        ctrl = 1;
        D0 = 8'hA5;
        D1 = 8'h5A;
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Select D0 with all 1s", test_num);
        ctrl = 0;
        D0 = 8'hFF;
        D1 = 8'h00;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Select D1 with all 1s", test_num);
        ctrl = 1;
        D0 = 8'h00;
        D1 = 8'hFF;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Select D0 with alternating bits", test_num);
        ctrl = 0;
        D0 = 8'hAA;
        D1 = 8'h55;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Select D1 with alternating bits", test_num);
        ctrl = 1;
        D0 = 8'hAA;
        D1 = 8'h55;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Both inputs same, ctrl=0", test_num);
        ctrl = 0;
        D0 = 8'h12;
        D1 = 8'h12;
        #1;

        check_outputs(8'h12);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Both inputs same, ctrl=1", test_num);
        ctrl = 1;
        D0 = 8'h12;
        D1 = 8'h12;
        #1;

        check_outputs(8'h12);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Zero inputs", test_num);
        ctrl = 0;
        D0 = 8'h00;
        D1 = 8'h00;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Random pattern test", test_num);
        ctrl = 1;
        D0 = 8'h3C;
        D1 = 8'hC3;
        #1;

        check_outputs(8'hC3);
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
        input [7:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: S=%h",
                         S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h",
                         expected_S);
                $display("  Got:      S=%h",
                         S);
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
