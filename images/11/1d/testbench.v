`timescale 1ns/1ps

module checksum_checker_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    wire [7:0] checksum_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    checksum_checker dut (
        .data_in(data_in),
        .checksum_out(checksum_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data = 8'h00 (All bits zero)", test_num);
            data_in = 8'h00;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data = 8'hFF (All bits one)", test_num);
            data_in = 8'hFF;
            #1;

            check_outputs(8'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data = 8'h01 (Single bit set)", test_num);
            data_in = 8'h01;
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data = 8'h80 (Single bit set)", test_num);
            data_in = 8'h80;
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data = 8'h03 (Two bits set)", test_num);
            data_in = 8'h03;
            #1;

            check_outputs(8'd2);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data = 8'hAA (Alternating pattern 10101010)", test_num);
            data_in = 8'hAA;
            #1;

            check_outputs(8'd4);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data = 8'h55 (Alternating pattern 01010101)", test_num);
            data_in = 8'h55;
            #1;

            check_outputs(8'd4);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data = 8'hF0 (Four bits set)", test_num);
            data_in = 8'hF0;
            #1;

            check_outputs(8'd4);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data = 8'h7F (Seven bits set)", test_num);
            data_in = 8'h7F;
            #1;

            check_outputs(8'd7);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data = 8'hE7 (Pattern 11100111)", test_num);
            data_in = 8'hE7;
            #1;

            check_outputs(8'd6);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("checksum_checker Testbench");
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
        input [7:0] expected_checksum_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_checksum_out === (expected_checksum_out ^ checksum_out ^ expected_checksum_out)) begin
                $display("PASS");
                $display("  Outputs: checksum_out=%h",
                         checksum_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum_out=%h",
                         expected_checksum_out);
                $display("  Got:      checksum_out=%h",
                         checksum_out);
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
