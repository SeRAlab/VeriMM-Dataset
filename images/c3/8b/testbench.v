`timescale 1ns/1ps

module bit_masking_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data_in;
    reg enable;
    reg [15:0] mask;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bit_masking dut (
        .data_in(data_in),
        .enable(enable),
        .mask(mask),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enable Low", test_num);
            enable = 0;
            data_in = 32'hFFFF_FFFF;
            mask = 16'hFFFF;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enable High, All 1s", test_num);
            enable = 1;
            data_in = 32'hFFFF_FFFF;
            mask = 16'hFFFF;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enable High, Zero Input", test_num);
            enable = 1;
            data_in = 32'hFFFF_0000;
            mask = 16'hFFFF;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enable High, Zero Mask", test_num);
            enable = 1;
            data_in = 32'hFFFF_FFFF;
            mask = 16'h0000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enable High, Alternating Bits (Matching)", test_num);
            enable = 1;
            data_in = 32'hAAAA_AAAA;
            mask = 16'hAAAA;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enable High, Alternating Bits (Non-matching)", test_num);
            enable = 1;
            data_in = 32'hAAAA_AAAA;
            mask = 16'h5555;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enable High, Partial Masking", test_num);
            enable = 1;
            data_in = 32'h1234_5678;
            mask = 16'hF0F0;

            #1;


            check_outputs(16'h5070);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Higher bits of input ignored", test_num);
            enable = 1;
            data_in = 32'hABCD_1234;
            mask = 16'hFFFF;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Dynamic Enable Toggle", test_num);
            data_in = 32'hFFFF_FFFF;
            mask = 16'h1234;
            enable = 1;
            #5;
            enable = 0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum data_in with specific mask", test_num);
            enable = 1;
            data_in = 32'hFFFF_FFFF;
            mask = 16'hCAFE;
            #1;

            check_outputs(16'hCAFE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bit_masking Testbench");
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
        input [15:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
