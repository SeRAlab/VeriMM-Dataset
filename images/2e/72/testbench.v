`timescale 1ns/1ps

module rle_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    wire [7:0] bit_value;
    wire [15:0] run_length;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rle_encoder dut (
        .data_in(data_in),
        .bit_value(bit_value),
        .run_length(run_length),
        .valid(valid)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All zeros", test_num);
        data_in = 8'b00000000;
        #1;

        check_outputs(8'h00, 16'd8, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All ones", test_num);
        data_in = 8'b11111111;
        #1;

        check_outputs(8'h01, 16'd8, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Leading four ones", test_num);
        data_in = 8'b11110000;
        #1;

        check_outputs(8'h01, 16'd4, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Leading four zeros", test_num);
        data_in = 8'b00001111;
        #1;

        check_outputs(8'h00, 16'd4, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Leading single one", test_num);
        data_in = 8'b10101010;
        #1;

        check_outputs(8'h01, 16'd1, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Leading single zero", test_num);
        data_in = 8'b01010101;
        #1;

        check_outputs(8'h00, 16'd1, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Run length of seven ones", test_num);
        data_in = 8'b11111110;
        #1;

        check_outputs(8'h01, 16'd7, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Run length of two zeros", test_num);
        data_in = 8'b00111111;
        #1;

        check_outputs(8'h00, 16'd2, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Run length of six ones", test_num);
        data_in = 8'b11111100;
        #1;

        check_outputs(8'h01, 16'd6, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Run length of three zeros", test_num);
        data_in = 8'b00011000;
        #1;

        check_outputs(8'h00, 16'd3, 1'b1);
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
        input [7:0] expected_bit_value;
        input [15:0] expected_run_length;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bit_value === (expected_bit_value ^ bit_value ^ expected_bit_value) &&
                expected_run_length === (expected_run_length ^ run_length ^ expected_run_length) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: bit_value=%h, run_length=%h, valid=%b",
                         bit_value, run_length, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bit_value=%h, run_length=%h, valid=%b",
                         expected_bit_value, expected_run_length, expected_valid);
                $display("  Got:      bit_value=%h, run_length=%h, valid=%b",
                         bit_value, run_length, valid);
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
