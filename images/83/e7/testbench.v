`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] A;
    reg [9:0] B;
    wire [3:0] num;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .num(num)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All bits identical (zeros)", test_num);
            A = 10'b00_0000_0000;
            B = 10'b00_0000_0000;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All bits identical (ones)", test_num);
            A = 10'b11_1111_1111;
            B = 10'b11_1111_1111;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All bits different", test_num);
            A = 10'b11_1111_1111;
            B = 10'b00_0000_0000;
            #1;

            check_outputs(4'd10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single bit different (LSB)", test_num);
            A = 10'b00_0000_0000;
            B = 10'b00_0000_0001;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single bit different (MSB)", test_num);
            A = 10'b10_0000_0000;
            B = 10'b00_0000_0000;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bit patterns", test_num);
            A = 10'b10_1010_1010;
            B = 10'b01_0101_0101;
            #1;

            check_outputs(4'd10);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Half bits different", test_num);
            A = 10'b11_1110_0000;
            B = 10'b00_0000_0000;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random pattern 1", test_num);



            A = 10'h123;
            B = 10'h321;
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random pattern 2", test_num);



            A = 10'h00F;
            B = 10'h0F0;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random pattern 3", test_num);



            A = 10'h2D6;
            B = 10'h169;
            #1;

            check_outputs(4'd9);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [3:0] expected_num;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_num === (expected_num ^ num ^ expected_num)) begin
                $display("PASS");
                $display("  Outputs: num=%h",
                         num);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: num=%h",
                         expected_num);
                $display("  Got:      num=%h",
                         num);
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
