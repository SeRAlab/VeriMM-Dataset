`timescale 1ns/1ps

module bin_to_bcd_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] bin_in;
    wire [7:0] bcd_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bin_to_bcd dut (
        .bin_in(bin_in),
        .bcd_out(bcd_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Binary 0", test_num);
            bin_in = 4'd0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Binary 5", test_num);
            bin_in = 4'd5;
            #1;

            check_outputs(8'h05);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Binary 9", test_num);
            bin_in = 4'd9;
            #1;

            check_outputs(8'h09);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Binary 10", test_num);
            bin_in = 4'd10;
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Binary 13", test_num);
            bin_in = 4'd13;
            #1;

            check_outputs(8'h13);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Binary 15", test_num);
            bin_in = 4'd15;
            #1;

            check_outputs(8'h15);
        end
        endtask

    task testcase007;

        integer i;
        reg [7:0] expected;
        begin
            $display("\nTest Case 007: Exhaustive Sweep 0-15");
            for (i = 0; i < 16; i = i + 1) begin
                test_num = test_num + 1;
                bin_in = i;

                if (i < 10)
                    expected = i;
                else
                    expected = {4'd1, (i[3:0] - 4'd10)};

                #1;


                check_outputs(expected);
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bin_to_bcd Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [7:0] expected_bcd_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bcd_out === (expected_bcd_out ^ bcd_out ^ expected_bcd_out)) begin
                $display("PASS");
                $display("  Outputs: bcd_out=%h",
                         bcd_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bcd_out=%h",
                         expected_bcd_out);
                $display("  Got:      bcd_out=%h",
                         bcd_out);
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
