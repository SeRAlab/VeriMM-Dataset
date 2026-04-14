`timescale 1ns/1ps

module dac_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] din;
    reg enable;
    wire [15:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dac dut (
        .din(din),
        .enable(enable),
        .dout(dout)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Enable low, Input 0xFFFF - Output should be 0x0000", test_num);
            enable = 0;
            din = 16'hFFFF;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Enable high, Input 0x0000 - Output should be 0x0000", test_num);
            enable = 1;
            din = 16'h0000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Enable high, Input 0xFFFF - Output should be 0xFFFF", test_num);
            enable = 1;
            din = 16'hFFFF;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Enable high, Input 0xAAAA - Output should be 0xAAAA", test_num);
            enable = 1;
            din = 16'hAAAA;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Enable high, Input 0x5555 - Output should be 0x5555", test_num);
            enable = 1;
            din = 16'h5555;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Enable high, Input 0x1234 - Output should be 0x1234", test_num);
            enable = 1;
            din = 16'h1234;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Disable (Enable 1->0) while Input is 0x1234 - Output should be 0x0000", test_num);
            enable = 0;
            din = 16'h1234;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Enable high, Input 0x8000 (Mid-scale) - Output should be 0x8000", test_num);
            enable = 1;
            din = 16'h8000;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dac Testbench");
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
        input [15:0] expected_dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
