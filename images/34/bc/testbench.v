`timescale 1ns/1ps

module huffman_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] char1;
    reg [7:0] char2;
    reg [7:0] char3;
    reg [7:0] char4;
    reg [7:0] char5;
    reg [3:0] freq1;
    reg [3:0] freq2;
    reg [3:0] freq3;
    reg [3:0] freq4;
    reg [3:0] freq5;
    wire [15:0] code1;
    wire [15:0] code2;
    wire [15:0] code3;
    wire [15:0] code4;
    wire [15:0] code5;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    huffman_encoder dut (
        .char1(char1),
        .char2(char2),
        .char3(char3),
        .char4(char4),
        .char5(char5),
        .freq1(freq1),
        .freq2(freq2),
        .freq3(freq3),
        .freq4(freq4),
        .freq5(freq5),
        .code1(code1),
        .code2(code2),
        .code3(code3),
        .code4(code4),
        .code5(code5)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Exponential Frequencies", test_num);
        char1 = "A"; freq1 = 4'd1;
        char2 = "B"; freq2 = 4'd2;
        char3 = "C"; freq3 = 4'd4;
        char4 = "D"; freq4 = 4'd8;
        char5 = "E"; freq5 = 4'd15;


        #1;



        check_outputs(16'b0000, 16'b0001, 16'b001, 16'b01, 16'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Uniform Frequencies", test_num);
        char1 = "A"; freq1 = 4'd5;
        char2 = "B"; freq2 = 4'd5;
        char3 = "C"; freq3 = 4'd5;
        char4 = "D"; freq4 = 4'd5;
        char5 = "E"; freq5 = 4'd5;


        #1;



        check_outputs(16'h0, 16'h1, 16'h2, 16'h6, 16'h7);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Single Dominant Character", test_num);
        char1 = "A"; freq1 = 4'd1;
        char2 = "B"; freq2 = 4'd1;
        char3 = "C"; freq3 = 4'd1;
        char4 = "D"; freq4 = 4'd1;
        char5 = "E"; freq5 = 4'd14;

        #1;


        check_outputs(16'b0000, 16'b0001, 16'b0010, 16'b0011, 16'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Paired Frequencies", test_num);
        char1 = "A"; freq1 = 4'd2;
        char2 = "B"; freq2 = 4'd2;
        char3 = "C"; freq3 = 4'd10;
        char4 = "D"; freq4 = 4'd10;
        char5 = "E"; freq5 = 4'd1;


        #1;



        check_outputs(16'hA, 16'hB, 16'h0, 16'h1, 16'h4);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Sparse Input (2 chars)", test_num);
        char1 = "X"; freq1 = 4'd10;
        char2 = "Y"; freq2 = 4'd10;
        char3 = " "; freq3 = 4'd0;
        char4 = " "; freq4 = 4'd0;
        char5 = " "; freq5 = 4'd0;

        #1;


        check_outputs(16'b0, 16'b1, 16'hFFFF, 16'hFFFF, 16'hFFFF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("huffman_encoder Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [15:0] expected_code1;
        input [15:0] expected_code2;
        input [15:0] expected_code3;
        input [15:0] expected_code4;
        input [15:0] expected_code5;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_code1 === (expected_code1 ^ code1 ^ expected_code1) &&
                expected_code2 === (expected_code2 ^ code2 ^ expected_code2) &&
                expected_code3 === (expected_code3 ^ code3 ^ expected_code3) &&
                expected_code4 === (expected_code4 ^ code4 ^ expected_code4) &&
                expected_code5 === (expected_code5 ^ code5 ^ expected_code5)) begin
                $display("PASS");
                $display("  Outputs: code1=%h, code2=%h, code3=%h, code4=%h, code5=%h",
                         code1, code2, code3, code4, code5);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: code1=%h, code2=%h, code3=%h, code4=%h, code5=%h",
                         expected_code1, expected_code2, expected_code3, expected_code4, expected_code5);
                $display("  Got:      code1=%h, code2=%h, code3=%h, code4=%h, code5=%h",
                         code1, code2, code3, code4, code5);
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
