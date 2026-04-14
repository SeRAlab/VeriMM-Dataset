`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] cur_addr;
    reg [7:0] disp;
    wire [11:0] disp_addr;
    wire [11:0] one_addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cur_addr(cur_addr),
        .disp(disp),
        .disp_addr(disp_addr),
        .one_addr(one_addr)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Minimal values", test_num);
            cur_addr = 12'd0; disp = 8'd0;

            #1;


            check_outputs(12'd1, 12'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive displacement boundary (127)", test_num);
            cur_addr = 12'd100; disp = 8'd127;

            #1;


            check_outputs(12'd228, 12'd101);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative displacement boundary (128)", test_num);
            cur_addr = 12'd500; disp = 8'd128;

            #1;


            check_outputs(12'd373, 12'd501);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum negative displacement (255 is -1)", test_num);
            cur_addr = 12'd1000; disp = 8'd255;

            #1;


            check_outputs(12'd1000, 12'd1001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Address wrap-around on one_addr", test_num);
            cur_addr = 12'hFFF; disp = 8'd0;

            #1;


            check_outputs(12'd0, 12'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive displacement with address wrap", test_num);
            cur_addr = 12'hFFF; disp = 8'd10;

            #1;


            check_outputs(12'd10, 12'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative displacement resulting in wrap-under", test_num);
            cur_addr = 12'd50; disp = 8'd200;

            #1;


            check_outputs(12'd4091, 12'd51);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mid-range positive values", test_num);
            cur_addr = 12'hABC; disp = 8'h10;

            #1;


            check_outputs(12'hACD, 12'hABD);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mid-range negative values", test_num);
            cur_addr = 12'h800; disp = 8'h96;

            #1;


            check_outputs(12'h797, 12'h801);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large address and high displacement", test_num);
            cur_addr = 12'hF00; disp = 8'h7F;

            #1;


            check_outputs(12'hF80, 12'hF01);
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
        input [11:0] expected_disp_addr;
        input [11:0] expected_one_addr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_disp_addr === (expected_disp_addr ^ disp_addr ^ expected_disp_addr) &&
                expected_one_addr === (expected_one_addr ^ one_addr ^ expected_one_addr)) begin
                $display("PASS");
                $display("  Outputs: disp_addr=%h, one_addr=%h",
                         disp_addr, one_addr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: disp_addr=%h, one_addr=%h",
                         expected_disp_addr, expected_one_addr);
                $display("  Got:      disp_addr=%h, one_addr=%h",
                         disp_addr, one_addr);
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
