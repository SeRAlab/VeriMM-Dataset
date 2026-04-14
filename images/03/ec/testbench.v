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
            $display("Test %0d: Multiply by Zero", test_num);
            A = 64'hFEDCBA9876543210;
            B = 64'h0000000000000000;
            #1;

            check_outputs(128'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiply by One", test_num);
            A = 64'hA5A5A5A55A5A5A5A;
            B = 64'h0000000000000001;
            #1;

            check_outputs({64'h0, 64'hA5A5A5A55A5A5A5A});
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Small Integers (123 * 456)", test_num);
            A = 64'd123;
            B = 64'd456;
            #1;

            check_outputs(128'd56088);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Power of 2 (2^32 * 2^32)", test_num);
            A = 64'h0000000100000000;
            B = 64'h0000000100000000;
            #1;

            check_outputs(128'h00000000000000010000000000000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: (2^32-1) * (2^32-1)", test_num);
            A = 64'h00000000FFFFFFFF;
            B = 64'h00000000FFFFFFFF;

            #1;


            check_outputs(128'h0000000000000000FFFFFFFFFFFFFFFE00000001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max 64-bit unsigned (2^64-1)^2", test_num);
            A = 64'hFFFFFFFFFFFFFFFF;
            B = 64'hFFFFFFFFFFFFFFFF;

            #1;


            check_outputs(128'hFFFFFFFFFFFFFFFFFFFFFFFE0000000000000001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mixed High and Low bits", test_num);
            A = 64'h123456789ABCDEF0;
            B = 64'h0000000000000010;
            #1;

            check_outputs(128'h0000000000000000123456789ABCDEF00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bit carry across 64-bit boundary", test_num);
            A = 64'h8000000000000000;
            B = 64'h0000000000000002;
            #1;

            check_outputs(128'h00000000000000010000000000000000);
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
