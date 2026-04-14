`timescale 1ns/1ps

module bin_to_bcd_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] bin;
    wire [3:0] bcd_ones;
    wire [3:0] bcd_tens;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bin_to_bcd dut (
        .bin(bin),
        .bcd_ones(bcd_ones),
        .bcd_tens(bcd_tens)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Binary Input = 0", test_num);
            bin = 4'd0;
            #1;

            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Binary Input = 5", test_num);
            bin = 4'd5;
            #1;

            check_outputs(4'd5, 4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Binary Input = 9", test_num);
            bin = 4'd9;
            #1;

            check_outputs(4'd9, 4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Binary Input = 10", test_num);
            bin = 4'd10;
            #1;

            check_outputs(4'd0, 4'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Binary Input = 12", test_num);
            bin = 4'd12;
            #1;

            check_outputs(4'd2, 4'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Binary Input = 15", test_num);
            bin = 4'd15;
            #1;

            check_outputs(4'd5, 4'd1);
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
        input [3:0] expected_bcd_ones;
        input [3:0] expected_bcd_tens;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bcd_ones === (expected_bcd_ones ^ bcd_ones ^ expected_bcd_ones) &&
                expected_bcd_tens === (expected_bcd_tens ^ bcd_tens ^ expected_bcd_tens)) begin
                $display("PASS");
                $display("  Outputs: bcd_ones=%h, bcd_tens=%h",
                         bcd_ones, bcd_tens);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bcd_ones=%h, bcd_tens=%h",
                         expected_bcd_ones, expected_bcd_tens);
                $display("  Got:      bcd_ones=%h, bcd_tens=%h",
                         bcd_ones, bcd_tens);
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
