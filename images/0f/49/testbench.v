`timescale 1ns/1ps

module checksum_calculator_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in;
    wire [7:0] checksum_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    checksum_calculator dut (
        .data_in(data_in),
        .checksum_out(checksum_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: All zeros", test_num);
            data_in = 16'h0000;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Small byte values", test_num);
            data_in = 16'h0102;
            #1;

            check_outputs(8'h03);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Maximum byte values (Overflow check)", test_num);
            data_in = 16'hFFFF;
            #1;

            check_outputs(8'hFE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Overflow to zero", test_num);
            data_in = 16'h8080;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Alternating bits", test_num);
            data_in = 16'h55AA;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Arbitrary values", test_num);
            data_in = 16'h1234;
            #1;

            check_outputs(8'h46);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: High byte carry", test_num);
            data_in = 16'hFE01;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Large values with carry", test_num);
            data_in = 16'hAABB;
            #1;

            check_outputs(8'h65);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("checksum_calculator Testbench");
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
