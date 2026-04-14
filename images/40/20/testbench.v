`timescale 1ns/1ps

module multiplier_64x64_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] A;
    reg [63:0] B;
    wire [127:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier_64x64 dut (
        .A(A),
        .B(B),
        .P(P)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Multiplication by Zero", test_num);
            A = 64'h0;
            B = 64'h0;
            #1;

            check_outputs(128'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Multiplication by Zero (one operand)", test_num);
            A = 64'hFFFFFFFFFFFFFFFF;
            B = 64'h0;
            #1;

            check_outputs(128'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Multiplicative Identity", test_num);
            A = 64'h1;
            B = 64'hFFFFFFFFFFFFFFFF;
            #1;

            check_outputs({64'h0, 64'hFFFFFFFFFFFFFFFF});
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Maximum Unsigned Values", test_num);
            A = 64'hFFFFFFFFFFFFFFFF;
            B = 64'hFFFFFFFFFFFFFFFF;

            #1;


            check_outputs(128'hFFFFFFFFFFFFFFFE0000000000000001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Power of 2 (32-bit crossing)", test_num);
            A = 64'h0000000100000000;
            B = 64'h0000000100000000;
            #1;

            check_outputs(128'h00000000000000010000000000000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Alternating Bit Patterns", test_num);
            A = 64'hAAAAAAAAAAAAAAAA;
            B = 64'h5555555555555555;

            #1;


            check_outputs(64'hAAAAAAAAAAAAAAAA * 64'h5555555555555555);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Small Constants", test_num);
            A = 64'd123456789;
            B = 64'd987654321;
            #1;

            check_outputs(128'd121932631112635269);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Large Value Carry Logic", test_num);
            A = 64'h8000000000000000;
            B = 64'h2;
            #1;

            check_outputs(128'h00000000000000010000000000000000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Prime-like Large Numbers", test_num);
            A = 64'hDEADC0DEBEEFCAFE;
            B = 64'hCAFEBABE12345678;
            #1;

            check_outputs(64'hDEADC0DEBEEFCAFE * 64'hCAFEBABE12345678);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Single Bit Set High", test_num);
            A = 64'h8000000000000000;
            B = 64'h8000000000000000;
            #1;

            check_outputs(128'h40000000000000000000000000000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier_64x64 Testbench");
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
        input [127:0] expected_P;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: P=%h",
                         P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h",
                         expected_P);
                $display("  Got:      P=%h",
                         P);
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
