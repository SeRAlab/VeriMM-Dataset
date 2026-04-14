`timescale 1ns/1ps

module huffman_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] frequencies;
    reg [23:0] symbols;
    wire [47:0] codes;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    huffman_encoder dut (
        .frequencies(frequencies),
        .symbols(symbols),
        .codes(codes)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Fibonacci Distribution", test_num);

            symbols = 24'h654321;
            frequencies = 24'hD85321;


            #1;



            check_outputs(48'h0002060E1E1F);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Uniform Distribution", test_num);
            symbols = 24'hABCDEF;
            frequencies = 24'h888888;


            #1;



            check_outputs(48'h000101020301);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Power of Two Distribution", test_num);
            symbols = 24'h123456;
            frequencies = 24'hF84211;

            #1;


            check_outputs(48'h0002060E1E1F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mixed Distribution", test_num);

            symbols = 24'hABCDEF;
            frequencies = 24'h5A2183;


            #1;



            check_outputs(48'h010002050E0F);
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
        input [47:0] expected_codes;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_codes === (expected_codes ^ codes ^ expected_codes)) begin
                $display("PASS");
                $display("  Outputs: codes=%h",
                         codes);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: codes=%h",
                         expected_codes);
                $display("  Got:      codes=%h",
                         codes);
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
