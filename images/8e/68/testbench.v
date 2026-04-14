`timescale 1ns/1ps

module bit_counter_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    wire [3:0] count_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bit_counter dut (
        .data_in(data_in),
        .count_out(count_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: All zeros", test_num);
            data_in = 8'b0000_0000;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: All ones", test_num);
            data_in = 8'b1111_1111;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Single bit (LSB)", test_num);
            data_in = 8'b0000_0001;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Single bit (MSB)", test_num);
            data_in = 8'b1000_0000;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Alternating bits (01010101)", test_num);
            data_in = 8'b0101_0101;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Alternating bits (10101010)", test_num);
            data_in = 8'b1010_1010;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Upper nibble ones", test_num);
            data_in = 8'b1111_0000;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Lower nibble ones", test_num);
            data_in = 8'b0000_1111;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Seven bits set", test_num);
            data_in = 8'b0111_1111;
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Random pattern (10110110)", test_num);
            data_in = 8'b1011_0110;
            #1;

            check_outputs(4'd5);
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
        input [3:0] expected_count_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_count_out === (expected_count_out ^ count_out ^ expected_count_out)) begin
                $display("PASS");
                $display("  Outputs: count_out=%h",
                         count_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_out=%h",
                         expected_count_out);
                $display("  Got:      count_out=%h",
                         count_out);
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
