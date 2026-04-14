`timescale 1ns/1ps

module bit_check_tb;

    // Testbench signals (combinational circuit)
    reg [13:0] signal;
    wire [12:0] and_result;
    wire [12:0] or_result;
    wire [13:0] xor_result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bit_check dut (
        .signal(signal),
        .and_result(and_result),
        .or_result(or_result),
        .xor_result(xor_result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            signal = 14'h0000;
            #1;

            check_outputs(13'h0000, 13'h0000, 14'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            signal = 14'h3FFF;

            #1;


            check_outputs(13'h1FFF, 13'h1FFF, 14'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating 1010...", test_num);
            signal = 14'h2AAA;



            #1;




            check_outputs(13'h0000, 13'h1FFF, 14'h3FFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating 0101...", test_num);
            signal = 14'h1555;
            #1;

            check_outputs(13'h0000, 13'h1FFF, 14'h3FFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern 1A5C", test_num);
            signal = 14'h1A5C;



            #1;




            check_outputs(13'h080C, 13'h1F7E, 14'h1772);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single LSB", test_num);
            signal = 14'h0001;



            #1;




            check_outputs(13'h0000, 13'h0001, 14'h2001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single MSB", test_num);
            signal = 14'h2000;



            #1;




            check_outputs(13'h0000, 13'h1000, 14'h3000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Wrap Around and Adjacency", test_num);
            signal = 14'h3001;



            #1;




            check_outputs(13'h1000, 13'h1801, 14'h0801);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bit_check Testbench");
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
        input [12:0] expected_and_result;
        input [12:0] expected_or_result;
        input [13:0] expected_xor_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_and_result === (expected_and_result ^ and_result ^ expected_and_result) &&
                expected_or_result === (expected_or_result ^ or_result ^ expected_or_result) &&
                expected_xor_result === (expected_xor_result ^ xor_result ^ expected_xor_result)) begin
                $display("PASS");
                $display("  Outputs: and_result=%h, or_result=%h, xor_result=%h",
                         and_result, or_result, xor_result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: and_result=%h, or_result=%h, xor_result=%h",
                         expected_and_result, expected_or_result, expected_xor_result);
                $display("  Got:      and_result=%h, or_result=%h, xor_result=%h",
                         and_result, or_result, xor_result);
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
