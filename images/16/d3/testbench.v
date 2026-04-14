`timescale 1ns/1ps

module huffman_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] freq0;
    reg [7:0] freq1;
    reg [7:0] freq2;
    reg [7:0] freq3;
    reg [7:0] freq4;
    wire [2:0] code0;
    wire [2:0] code1;
    wire [2:0] code2;
    wire [2:0] code3;
    wire [2:0] code4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    huffman_encoder dut (
        .freq0(freq0),
        .freq1(freq1),
        .freq2(freq2),
        .freq3(freq3),
        .freq4(freq4),
        .code0(code0),
        .code1(code1),
        .code2(code2),
        .code3(code3),
        .code4(code4)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Balanced Frequencies (10, 10, 10, 10, 10)", test_num);
            freq0 = 8'd10; freq1 = 8'd10; freq2 = 8'd10; freq3 = 8'd10; freq4 = 8'd10;


            #1;



            check_outputs(3'b110, 3'b111, 3'b000, 3'b010, 3'b100);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Skewed Frequencies (100, 2, 2, 2, 2)", test_num);
            freq0 = 8'd100; freq1 = 8'd2; freq2 = 8'd2; freq3 = 8'd2; freq4 = 8'd2;


            #1;



            check_outputs(3'b100, 3'b000, 3'b001, 3'b010, 3'b011);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Linear Increments (5, 10, 15, 20, 25)", test_num);
            freq0 = 8'd5; freq1 = 8'd10; freq2 = 8'd15; freq3 = 8'd20; freq4 = 8'd25;
            #1;

            check_outputs(3'b110, 3'b111, 3'b100, 3'b000, 3'b010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Two Dominant Groups (50, 50, 5, 5, 5)", test_num);
            freq0 = 8'd50; freq1 = 8'd50; freq2 = 8'd5; freq3 = 8'd5; freq4 = 8'd5;
            #1;

            check_outputs(3'b100, 3'b110, 3'b000, 3'b010, 3'b011);
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
        input [2:0] expected_code0;
        input [2:0] expected_code1;
        input [2:0] expected_code2;
        input [2:0] expected_code3;
        input [2:0] expected_code4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_code0 === (expected_code0 ^ code0 ^ expected_code0) &&
                expected_code1 === (expected_code1 ^ code1 ^ expected_code1) &&
                expected_code2 === (expected_code2 ^ code2 ^ expected_code2) &&
                expected_code3 === (expected_code3 ^ code3 ^ expected_code3) &&
                expected_code4 === (expected_code4 ^ code4 ^ expected_code4)) begin
                $display("PASS");
                $display("  Outputs: code0=%h, code1=%h, code2=%h, code3=%h, code4=%h",
                         code0, code1, code2, code3, code4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: code0=%h, code1=%h, code2=%h, code3=%h, code4=%h",
                         expected_code0, expected_code1, expected_code2, expected_code3, expected_code4);
                $display("  Got:      code0=%h, code1=%h, code2=%h, code3=%h, code4=%h",
                         code0, code1, code2, code3, code4);
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
