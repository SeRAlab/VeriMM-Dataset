`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [39:0] dig;
    reg [2:0] num;
    wire [4:0] code;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dig(dig),
        .num(num),
        .code(code)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select num=0 (dig[4:0])", test_num);
            dig = {5'd31, 5'd30, 5'd29, 5'd28, 5'd27, 5'd26, 5'd25, 5'd24};
            num = 3'd0;
            #1;

            check_outputs(5'd24);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select num=1 (dig[9:5])", test_num);
            dig = {5'd31, 5'd30, 5'd29, 5'd28, 5'd27, 5'd26, 5'd25, 5'd24};
            num = 3'd1;
            #1;

            check_outputs(5'd25);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select num=2 (dig[14:10])", test_num);
            dig = {5'd31, 5'd30, 5'd29, 5'd28, 5'd27, 5'd26, 5'd25, 5'd24};
            num = 3'd2;
            #1;

            check_outputs(5'd26);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select num=3 (dig[19:15])", test_num);
            dig = {5'd31, 5'd30, 5'd29, 5'd28, 5'd27, 5'd26, 5'd25, 5'd24};
            num = 3'd3;
            #1;

            check_outputs(5'd27);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select num=4 (dig[24:20])", test_num);
            dig = {5'd31, 5'd30, 5'd29, 5'd28, 5'd27, 5'd26, 5'd25, 5'd24};
            num = 3'd4;
            #1;

            check_outputs(5'd28);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select num=5 (dig[29:25])", test_num);
            dig = {5'd31, 5'd30, 5'd29, 5'd28, 5'd27, 5'd26, 5'd25, 5'd24};
            num = 3'd5;
            #1;

            check_outputs(5'd29);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select num=6 (dig[34:30])", test_num);
            dig = {5'd31, 5'd30, 5'd29, 5'd28, 5'd27, 5'd26, 5'd25, 5'd24};
            num = 3'd6;
            #1;

            check_outputs(5'd30);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select num=7 (dig[39:35])", test_num);
            dig = {5'd31, 5'd30, 5'd29, 5'd28, 5'd27, 5'd26, 5'd25, 5'd24};
            num = 3'd7;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All ones input test", test_num);
            dig = 40'hFFFFFFFFFF;
            num = 3'd4;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero pattern test", test_num);
            dig = 40'h0000000000;
            num = 3'd2;
            #1;

            check_outputs(5'h00);
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
        input [4:0] expected_code;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_code === (expected_code ^ code ^ expected_code)) begin
                $display("PASS");
                $display("  Outputs: code=%h",
                         code);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: code=%h",
                         expected_code);
                $display("  Got:      code=%h",
                         code);
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
