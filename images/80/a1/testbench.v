`timescale 1ns/1ps

module binary_decoder_5to32_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] bin_in;
    reg en;
    wire [31:0] one_hot_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_decoder_5to32 dut (
        .bin_in(bin_in),
        .en(en),
        .one_hot_out(one_hot_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Enable low, input zero", test_num);
            en = 1'b0;
            bin_in = 5'b00000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Enable low, input max", test_num);
            en = 1'b0;
            bin_in = 5'b11111;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Enable high, input 0", test_num);
            en = 1'b1;
            bin_in = 5'd0;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Enable high, input 1", test_num);
            en = 1'b1;
            bin_in = 5'd1;
            #1;

            check_outputs(32'h00000002);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Enable high, input 10", test_num);
            en = 1'b1;
            bin_in = 5'd10;
            #1;

            check_outputs(32'h00000400);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Enable high, input 15", test_num);
            en = 1'b1;
            bin_in = 5'd15;
            #1;

            check_outputs(32'h00008000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Enable high, input 16", test_num);
            en = 1'b1;
            bin_in = 5'd16;
            #1;

            check_outputs(32'h00010000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Enable high, input 31", test_num);
            en = 1'b1;
            bin_in = 5'd31;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Dynamic transition test (10 to 11)", test_num);
            en = 1'b1;
            bin_in = 5'd10;
            #5;
            bin_in = 5'd11;
            #1;

            check_outputs(32'h00000800);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Enable toggling with input 5", test_num);
            bin_in = 5'd5;
            en = 1'b1;
            #5;
            en = 1'b0;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_decoder_5to32 Testbench");
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
        input [31:0] expected_one_hot_out;
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
