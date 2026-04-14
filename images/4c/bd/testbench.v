`timescale 1ns/1ps

module binary_decoder_4to16_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] bin_in;
    reg en;
    wire [15:0] one_hot_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_decoder_4to16 dut (
        .bin_in(bin_in),
        .en(en),
        .one_hot_out(one_hot_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Enable low (bin_in=0)", test_num);
            en = 1'b0;
            bin_in = 4'd0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Enable low (bin_in=15)", test_num);
            en = 1'b0;
            bin_in = 4'd15;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Enable high, input 0", test_num);
            en = 1'b1;
            bin_in = 4'd0;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Enable high, input 1", test_num);
            en = 1'b1;
            bin_in = 4'd1;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Enable high, input 4", test_num);
            en = 1'b1;
            bin_in = 4'd4;
            #1;

            check_outputs(16'h0010);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Enable high, input 7", test_num);
            en = 1'b1;
            bin_in = 4'd7;
            #1;

            check_outputs(16'h0080);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Enable high, input 8", test_num);
            en = 1'b1;
            bin_in = 4'd8;
            #1;

            check_outputs(16'h0100);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Enable high, input 12", test_num);
            en = 1'b1;
            bin_in = 4'd12;
            #1;

            check_outputs(16'h1000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Enable high, input 15", test_num);
            en = 1'b1;
            bin_in = 4'd15;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Transition En 1->0 while input is 5", test_num);
            en = 1'b1;
            bin_in = 4'd5;
            #5;
            en = 1'b0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_decoder_4to16 Testbench");
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
        input [15:0] expected_one_hot_out;
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
