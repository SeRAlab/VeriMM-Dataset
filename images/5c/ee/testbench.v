`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] RGB565;
    wire [7:0] RGB332;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .RGB565(RGB565),
        .RGB332(RGB332)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Black (All Zeros)", test_num);
            RGB565 = 16'h0000;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: White (All Ones)", test_num);
            RGB565 = 16'hFFFF;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pure Red (Max)", test_num);

            RGB565 = 16'hF800;

            #1;


            check_outputs(8'hE0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pure Green (Max)", test_num);

            RGB565 = 16'h07E0;

            #1;


            check_outputs(8'h1C);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pure Blue (Max)", test_num);

            RGB565 = 16'h001F;

            #1;


            check_outputs(8'h03);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed Color 1 (0xABCD)", test_num);


            RGB565 = 16'hABCD;

            #1;


            check_outputs(8'hAD);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed Color 2 (0x1234)", test_num);


            RGB565 = 16'h1234;

            #1;


            check_outputs(8'h0A);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern Check (Alternating Bits)", test_num);


            RGB565 = 16'hAAAA;

            #1;


            check_outputs(8'hA9);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Check (LSBs of 565 Ignored)", test_num);


            RGB565 = 16'h18E7;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-range Values", test_num);


            RGB565 = 16'h8410;

            #1;


            check_outputs(8'h92);
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
        input [7:0] expected_RGB332;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_RGB332 === (expected_RGB332 ^ RGB332 ^ expected_RGB332)) begin
                $display("PASS");
                $display("  Outputs: RGB332=%h",
                         RGB332);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RGB332=%h",
                         expected_RGB332);
                $display("  Got:      RGB332=%h",
                         RGB332);
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
