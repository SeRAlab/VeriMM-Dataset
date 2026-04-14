`timescale 1ns/1ps

module priority_encoder_12bit_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] data_in;
    wire [3:0] encoded;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder_12bit dut (
        .data_in(data_in),
        .encoded(encoded),
        .valid(valid)
    );
    task testcase001;

    begin
        test_num = 1;
        data_in = 12'b0000_0000_0000;
        $display("Test %0d: All inputs zero", test_num);
        #1;

        check_outputs(4'd0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        data_in = 12'b0000_0000_0001;
        $display("Test %0d: Only bit 0 is high", test_num);
        #1;

        check_outputs(4'd0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        data_in = 12'b1000_0000_0000;
        $display("Test %0d: Only bit 11 is high", test_num);
        #1;

        check_outputs(4'd11, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        data_in = 12'b0000_1000_0000;
        $display("Test %0d: Only bit 7 is high", test_num);
        #1;

        check_outputs(4'd7, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        data_in = 12'b0000_1000_0001;
        $display("Test %0d: Multiple bits high (7 and 0), bit 7 should win", test_num);
        #1;

        check_outputs(4'd7, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        data_in = 12'b1111_1111_1111;
        $display("Test %0d: All bits high, bit 11 should win", test_num);
        #1;

        check_outputs(4'd11, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        data_in = 12'b0000_0011_1100;
        $display("Test %0d: Cluster of bits (5,4,3,2), bit 5 should win", test_num);
        #1;

        check_outputs(4'd5, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        data_in = 12'b0101_0101_0101;
        $display("Test %0d: Alternating bits, bit 10 should win", test_num);
        #1;

        check_outputs(4'd10, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        data_in = 12'b0000_0000_0010;
        $display("Test %0d: Only bit 1 is high", test_num);
        #1;

        check_outputs(4'd1, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        data_in = 12'b0011_0000_0000;
        $display("Test %0d: Bits 9 and 8 high, bit 9 should win", test_num);
        #1;

        check_outputs(4'd9, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("priority_encoder_12bit Testbench");
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
        input [3:0] expected_encoded;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_encoded === (expected_encoded ^ encoded ^ expected_encoded) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: encoded=%h, valid=%b",
                         encoded, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded=%h, valid=%b",
                         expected_encoded, expected_valid);
                $display("  Got:      encoded=%h, valid=%b",
                         encoded, valid);
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
