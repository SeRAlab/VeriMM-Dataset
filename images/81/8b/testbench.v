`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] D0;
    reg [127:0] D1;
    reg ctrl;
    wire [127:0] S;

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
            test_num = test_num + 1;
            $display("Testcase %0d: Select D0 with simple pattern", test_num);
            ctrl = 1'b0;
            D0 = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
            D1 = 128'hBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB;
            #10;
            #1;

            check_outputs(128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select D1 with simple pattern", test_num);
            ctrl = 1'b1;
            D0 = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
            D1 = 128'hBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB;
            #10;
            #1;

            check_outputs(128'hBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select D0 (All ones vs All zeros)", test_num);
            ctrl = 1'b0;
            D0 = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            D1 = 128'h00000000000000000000000000000000;
            #10;
            #1;

            check_outputs(128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select D1 (All ones vs All zeros)", test_num);
            ctrl = 1'b1;
            D0 = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            D1 = 128'h00000000000000000000000000000000;
            #10;
            #1;

            check_outputs(128'h00000000000000000000000000000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select D0 with walking hex pattern", test_num);
            ctrl = 1'b0;
            D0 = 128'h0123456789ABCDEF0123456789ABCDEF;
            D1 = 128'hFEDCBA9876543210FEDCBA9876543210;
            #10;
            #1;

            check_outputs(128'h0123456789ABCDEF0123456789ABCDEF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select D1 with walking hex pattern", test_num);
            ctrl = 1'b1;
            D0 = 128'h0123456789ABCDEF0123456789ABCDEF;
            D1 = 128'hFEDCBA9876543210FEDCBA9876543210;
            #10;
            #1;

            check_outputs(128'hFEDCBA9876543210FEDCBA9876543210);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select D0 with alternating bit pattern", test_num);
            ctrl = 1'b0;
            D0 = 128'h55555555555555555555555555555555;
            D1 = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
            #10;
            #1;

            check_outputs(128'h55555555555555555555555555555555);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select D1 with alternating bit pattern", test_num);
            ctrl = 1'b1;
            D0 = 128'h55555555555555555555555555555555;
            D1 = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
            #10;
            #1;

            check_outputs(128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA);
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
        input [127:0] expected_S;
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
