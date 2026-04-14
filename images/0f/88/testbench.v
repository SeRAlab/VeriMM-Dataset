`timescale 1ns/1ps

module comb_logic_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    wire [31:0] C;
    wire even;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    comb_logic dut (
        .A(A),
        .B(B),
        .C(C),
        .even(even)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros", test_num);
            A = 32'h0000_0000;
            B = 32'h0000_0000;

            #1;


            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones", test_num);
            A = 32'hFFFF_FFFF;
            B = 32'hFFFF_FFFF;

            #1;


            check_outputs(32'hFFFF_FFFF, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed bits - Result Even", test_num);
            A = 32'hAAAA_AAA0;
            B = 32'h5555_5550;

            #1;


            check_outputs(32'hFFFF_FFF0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed bits - Result Odd", test_num);
            A = 32'hAAAA_AAA0;
            B = 32'h5555_5551;

            #1;


            check_outputs(32'hFFFF_FFF1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: AND/XOR Overlap Check", test_num);
            A = 32'hF0F0_F0F0;
            B = 32'h0F0F_0F0F;

            #1;


            check_outputs(32'hFFFF_FFFF, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Hex Pattern Even", test_num);
            A = 32'h1234_5678;
            B = 32'h8765_4320;

            #1;


            check_outputs(32'h9775_5778, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Only LSB 1 on B", test_num);
            A = 32'hFFFF_FFFE;
            B = 32'h0000_0001;

            #1;


            check_outputs(32'hFFFF_FFFF, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large values - MSB only", test_num);
            A = 32'h8000_0000;
            B = 32'h8000_0000;

            #1;


            check_outputs(32'h8000_0000, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sparse bits", test_num);
            A = 32'h0000_0002;
            B = 32'h0000_0004;

            #1;


            check_outputs(32'h0000_0006, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verification of (A&B)|(A^B)", test_num);
            A = 32'h1111_1111;
            B = 32'h1111_1111;

            #1;


            check_outputs(32'h1111_1111, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("comb_logic Testbench");
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
        input [31:0] expected_C;
        input expected_even;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_even === (expected_even ^ even ^ expected_even)) begin
                $display("PASS");
                $display("  Outputs: C=%h, even=%b",
                         C, even);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h, even=%b",
                         expected_C, expected_even);
                $display("  Got:      C=%h, even=%b",
                         C, even);
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
