`timescale 1ns/1ps

module RLE_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    wire [15:0] rle_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RLE dut (
        .data_in(data_in),
        .rle_out(rle_out),
        .valid(valid)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros", test_num);
        data_in = 8'b00000000;

        #1;


        check_outputs(16'h0800, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Ones", test_num);
        data_in = 8'b11111111;

        #1;


        check_outputs(16'h8800, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 4 Ones followed by 4 Zeros", test_num);
        data_in = 8'b11110000;

        #1;


        check_outputs(16'h8404, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 4 Zeros followed by 4 Ones", test_num);
        data_in = 8'b00001111;

        #1;


        check_outputs(16'h0484, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single 1 followed by 7 Zeros", test_num);
        data_in = 8'b10000000;

        #1;


        check_outputs(16'h8107, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single 0 followed by 7 Ones", test_num);
        data_in = 8'b01111111;

        #1;


        check_outputs(16'h0187, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating Bits (First Two Pairs)", test_num);
        data_in = 8'b10101010;


        #1;



        check_outputs(16'h8101, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 6 Zeros, 2 Ones", test_num);
        data_in = 8'b00000011;

        #1;


        check_outputs(16'h0682, 1'b1);
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
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rle_out === (expected_rle_out ^ rle_out ^ expected_rle_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: rle_out=%h, valid=%b",
                         rle_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rle_out=%h, valid=%b",
                         expected_rle_out, expected_valid);
                $display("  Got:      rle_out=%h, valid=%b",
                         rle_out, valid);
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
