`timescale 1ns/1ps

module bit_counter_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] D;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bit_counter dut (
        .D(D),
        .count(count)
    );
    task testcase001;

        begin
            test_num = 1;
            D = 16'h0000;
            $display("Test %0d: All bits zero", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            D = 16'h0001;
            $display("Test %0d: Least Significant Bit set", test_num);
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            D = 16'h8000;
            $display("Test %0d: Most Significant Bit set", test_num);
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            D = 16'h5555;
            $display("Test %0d: Alternating bits (0101 pattern)", test_num);
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            D = 16'hAAAA;
            $display("Test %0d: Alternating bits (1010 pattern)", test_num);
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            D = 16'h00FF;
            $display("Test %0d: Lower 8 bits set", test_num);
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            D = 16'h1234;
            $display("Test %0d: Sparse pattern 0x1234", test_num);
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            D = 16'hFE71;
            $display("Test %0d: High density pattern 0xFE71", test_num);
            #1;

            check_outputs(4'd11);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            D = 16'h7FFF;
            $display("Test %0d: 15 bits set", test_num);
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            D = 16'hFFFF;
            $display("Test %0d: All 16 bits set (Checks 4-bit truncation)", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bit_counter Testbench");
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
        input [3:0] expected_count;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
