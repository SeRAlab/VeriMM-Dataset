`timescale 1ns/1ps

module mux2to1_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg S;
    wire [31:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux2to1 dut (
        .A(A),
        .B(B),
        .S(S),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select A (S=0)", test_num);
            A = 32'hAAAA_BBBB;
            B = 32'hCCCC_DDDD;
            S = 1'b0;
            #1;

            check_outputs(32'hAAAA_BBBB);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select B (S=1)", test_num);
            A = 32'hAAAA_BBBB;
            B = 32'hCCCC_DDDD;
            S = 1'b1;
            #1;

            check_outputs(32'hCCCC_DDDD);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros, select A", test_num);
            A = 32'h0000_0000;
            B = 32'hFFFF_FFFF;
            S = 1'b0;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones, select B", test_num);
            A = 32'h0000_0000;
            B = 32'hFFFF_FFFF;
            S = 1'b1;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bits, select A", test_num);
            A = 32'h5555_5555;
            B = 32'hAAAA_AAAA;
            S = 1'b0;
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bits, select B", test_num);
            A = 32'h5555_5555;
            B = 32'hAAAA_AAAA;
            S = 1'b1;
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single bit toggle A, select A", test_num);
            A = 32'h0000_0001;
            B = 32'h0000_0000;
            S = 1'b0;
            #1;

            check_outputs(32'h0000_0001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Hex Pattern, select B", test_num);
            A = 32'h1234_5678;
            B = 32'hDEAD_BEEF;
            S = 1'b1;
            #1;

            check_outputs(32'hDEAD_BEEF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux2to1 Testbench");
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
        input [31:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
