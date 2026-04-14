`timescale 1ns/1ps

module bit_checker_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bit_checker dut (
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: All bits zero", test_num);
            in = 16'h0000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: LSB bit set (bit 0)", test_num);
            in = 16'h0001;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: MSB bit set (bit 15)", test_num);
            in = 16'h8000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: All bits set", test_num);
            in = 16'hFFFF;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Middle bit set (bit 7)", test_num);
            in = 16'h0080;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Alternating bits (0xAAAA)", test_num);
            in = 16'hAAAA;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest Case %0d: Alternating bits (0x5555)", test_num);
            in = 16'h5555;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTest Case %0d: Multiple bits set in lower byte", test_num);
            in = 16'h001F;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("\nTest Case %0d: Multiple bits set in upper byte", test_num);
            in = 16'hF000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("\nTest Case %0d: Single bit near center (bit 8)", test_num);
            in = 16'h0100;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bit_checker Testbench");
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
                         out);
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
