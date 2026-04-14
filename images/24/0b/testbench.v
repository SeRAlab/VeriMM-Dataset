`timescale 1ns/1ps

module rle_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    wire [15:0] rle_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rle_encoder dut (
        .data_in(data_in),
        .rle_out(rle_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zeros input", test_num);
            data_in = 8'b0000_0000;
            #1;

            check_outputs(16'h0800);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All ones input", test_num);
            data_in = 8'b1111_1111;
            #1;

            check_outputs(16'h0801);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Leading ones (3 bits)", test_num);
            data_in = 8'b1110_0000;
            #1;

            check_outputs(16'h0301);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Leading zeros (5 bits)", test_num);
            data_in = 8'b0000_0111;
            #1;

            check_outputs(16'h0500);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits starting with 1", test_num);
            data_in = 8'b1010_1010;
            #1;

            check_outputs(16'h0101);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single leading zero", test_num);
            data_in = 8'b0110_0000;
            #1;

            check_outputs(16'h0100);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Seven leading ones", test_num);
            data_in = 8'b1111_1110;
            #1;

            check_outputs(16'h0701);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Seven leading zeros", test_num);
            data_in = 8'b0000_0001;
            #1;

            check_outputs(16'h0700);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rle_encoder Testbench");
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
        input [15:0] expected_rle_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rle_out === (expected_rle_out ^ rle_out ^ expected_rle_out)) begin
                $display("PASS");
                $display("  Outputs: rle_out=%h",
                         rle_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rle_out=%h",
                         expected_rle_out);
                $display("  Got:      rle_out=%h",
                         rle_out);
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
