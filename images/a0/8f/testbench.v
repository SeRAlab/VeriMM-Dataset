`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [7:0] Out6;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Out6(Out6)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 8'h00;
            B = 8'h00;
            $display("Test %0d: All Zeros inputs", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 8'hFF;
            B = 8'hFF;
            $display("Test %0d: All Ones inputs", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 8'hAA;
            B = 8'hAA;
            $display("Test %0d: Matching alternating bits", test_num);
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 8'hAA;
            B = 8'h55;
            $display("Test %0d: Complementary alternating bits", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 8'hF0;
            B = 8'h0F;
            $display("Test %0d: Nibble-wise complementary", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 8'hF0;
            B = 8'hFF;
            $display("Test %0d: Partial overlap", test_num);
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 8'h01;
            B = 8'h01;
            $display("Test %0d: Single bit set", test_num);
            #1;

            check_outputs(8'hFE);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 8'h12;
            B = 8'h34;
            $display("Test %0d: Pattern 0x12, 0x34", test_num);


            #1;



            check_outputs(8'hEF);
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
        input [7:0] expected_Out6;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Out6 === (expected_Out6 ^ Out6 ^ expected_Out6)) begin
                $display("PASS");
                $display("  Outputs: Out6=%h",
                         Out6);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Out6=%h",
                         expected_Out6);
                $display("  Got:      Out6=%h",
                         Out6);
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
