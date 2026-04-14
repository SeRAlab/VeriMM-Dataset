`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] addr;
    reg [3:0] ctrl;
    wire en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .ctrl(ctrl),
        .en(en)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All control bits zero, access denied", test_num);
            addr = 8'h00;
            ctrl = 4'b0000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Block 0 access permitted", test_num);
            addr = 8'h15;
            ctrl = 4'b0001;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Block 0 access denied (wrong control bit)", test_num);
            addr = 8'h15;
            ctrl = 4'b0010;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Block 1 access permitted", test_num);
            addr = 8'h45;
            ctrl = 4'b0010;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Block 2 boundary (0x80) permitted", test_num);
            addr = 8'h80;
            ctrl = 4'b0100;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Block 2 boundary (0xBF) permitted", test_num);
            addr = 8'hBF;
            ctrl = 4'b0100;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Block 3 access permitted", test_num);
            addr = 8'hE0;
            ctrl = 4'b1000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max address (0xFF) with all access enabled", test_num);
            addr = 8'hFF;
            ctrl = 4'b1111;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Block 1 access with multiple control bits set", test_num);
            addr = 8'h50;
            ctrl = 4'b1011;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transition from Block 0 to Block 1", test_num);
            addr = 8'h3F;
            ctrl = 4'b0010;
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
        input expected_en;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_en === (expected_en ^ en ^ expected_en)) begin
                $display("PASS");
                $display("  Outputs: en=%b",
                         en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: en=%b",
                         expected_en);
                $display("  Got:      en=%b",
                         en);
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
