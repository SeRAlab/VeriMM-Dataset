`timescale 1ns/1ps

module binary_decoder_6to64_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] bin_in;
    reg en;
    wire [63:0] one_hot_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_decoder_6to64 dut (
        .bin_in(bin_in),
        .en(en),
        .one_hot_out(one_hot_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Enable low, input 0", test_num);
        en = 0;
        bin_in = 6'd0;
        #1;

        check_outputs(64'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Enable low, input 63", test_num);
        en = 0;
        bin_in = 6'd63;
        #1;

        check_outputs(64'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Enable high, input 0 (LSB)", test_num);
        en = 1;
        bin_in = 6'd0;
        #1;

        check_outputs(64'h0000000000000001);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Enable high, input 1", test_num);
        en = 1;
        bin_in = 6'd1;
        #1;

        check_outputs(64'h0000000000000002);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Enable high, input 15", test_num);
        en = 1;
        bin_in = 6'd15;
        #1;

        check_outputs(64'h0000000000008000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Enable high, input 31", test_num);
        en = 1;
        bin_in = 6'd31;
        #1;

        check_outputs(64'h0000000080000000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Enable high, input 32", test_num);
        en = 1;
        bin_in = 6'd32;
        #1;

        check_outputs(64'h0000000100000000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Enable high, input 63 (MSB)", test_num);
        en = 1;
        bin_in = 6'd63;
        #1;

        check_outputs(64'h8000000000000000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Toggle Enable high to low", test_num);
        en = 1;
        bin_in = 6'd10;
        #1;
        en = 0;
        #1;

        check_outputs(64'h0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Enable high, input 10", test_num);
        en = 1;
        bin_in = 6'd10;
        #1;

        check_outputs(64'h0000000000000400);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_decoder_6to64 Testbench");
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
        input [63:0] expected_one_hot_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_one_hot_out === (expected_one_hot_out ^ one_hot_out ^ expected_one_hot_out)) begin
                $display("PASS");
                $display("  Outputs: one_hot_out=%h",
                         one_hot_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: one_hot_out=%h",
                         expected_one_hot_out);
                $display("  Got:      one_hot_out=%h",
                         one_hot_out);
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
