`timescale 1ns/1ps

module RLE_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    wire [3:0] count_out;
    wire [7:0] value_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RLE dut (
        .data_in(data_in),
        .count_out(count_out),
        .value_out(value_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            data_in = 8'b00000000;
            #1;

            check_outputs(4'd8, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones", test_num);
            data_in = 8'b11111111;
            #1;

            check_outputs(4'd8, 8'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single leading one", test_num);
            data_in = 8'b10000000;
            #1;

            check_outputs(4'd1, 8'h01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single leading zero", test_num);
            data_in = 8'b01111111;
            #1;

            check_outputs(4'd1, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Four ones followed by zeros", test_num);
            data_in = 8'b11110000;
            #1;

            check_outputs(4'd4, 8'h01);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Four zeros followed by ones", test_num);
            data_in = 8'b00001111;
            #1;

            check_outputs(4'd4, 8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Seven ones followed by a zero", test_num);
            data_in = 8'b11111110;
            #1;

            check_outputs(4'd7, 8'h01);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating bits (10101010)", test_num);
            data_in = 8'b10101010;
            #1;

            check_outputs(4'd1, 8'h01);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating bits (01010101)", test_num);
            data_in = 8'b01010101;
            #1;

            check_outputs(4'd1, 8'h00);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Six zeros followed by two ones", test_num);
            data_in = 8'b00000011;
            #1;

            check_outputs(4'd6, 8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("RLE Testbench");
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
        input [7:0] expected_value_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_count_out === (expected_count_out ^ count_out ^ expected_count_out) &&
                expected_value_out === (expected_value_out ^ value_out ^ expected_value_out)) begin
                $display("PASS");
                $display("  Outputs: count_out=%h, value_out=%h",
                         count_out, value_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_out=%h, value_out=%h",
                         expected_count_out, expected_value_out);
                $display("  Got:      count_out=%h, value_out=%h",
                         count_out, value_out);
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
