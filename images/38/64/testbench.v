`timescale 1ns/1ps

module hamming_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] D;
    wire [6:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hamming_encoder dut (
        .D(D),
        .C(C)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: All Zeros", test_num);
        D = 4'b0000;
        #1;

        check_outputs(7'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Single Data Bit D0", test_num);
        D = 4'b0001;
        #1;

        check_outputs(7'h07);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Single Data Bit D1", test_num);
        D = 4'b0010;
        #1;

        check_outputs(7'h19);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Single Data Bit D2", test_num);
        D = 4'b0100;
        #1;

        check_outputs(7'h2A);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Single Data Bit D3", test_num);
        D = 4'b1000;
        #1;

        check_outputs(7'h4B);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Mixed Bits (1011)", test_num);
        D = 4'b1011;
        #1;

        check_outputs(7'h55);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Mixed Bits (0110)", test_num);
        D = 4'b0110;
        #1;

        check_outputs(7'h33);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: All Ones", test_num);
        D = 4'b1111;
        #1;

        check_outputs(7'h7F);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hamming_encoder Testbench");
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
        input [6:0] expected_C;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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
