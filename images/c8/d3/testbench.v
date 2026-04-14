`timescale 1ns/1ps

module binary_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg C_in;
    wire [3:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_adder dut (
        .A(A),
        .B(B),
        .C_in(C_in),
        .S(S)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 4'd0;
            B = 4'd0;
            C_in = 1'b0;
            $display("Test %0d: Zero inputs - A=%d, B=%d, C_in=%b", test_num, A, B, C_in);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 4'd5;
            B = 4'd3;
            C_in = 1'b0;
            $display("Test %0d: Basic addition - A=%d, B=%d, C_in=%b", test_num, A, B, C_in);
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 4'd0;
            B = 4'd0;
            C_in = 1'b1;
            $display("Test %0d: Carry-in only - A=%d, B=%d, C_in=%b", test_num, A, B, C_in);
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 4'd7;
            B = 4'd2;
            C_in = 1'b1;
            $display("Test %0d: Addition with Carry-in - A=%d, B=%d, C_in=%b", test_num, A, B, C_in);
            #1;

            check_outputs(4'd10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 4'hf;
            B = 4'h0;
            C_in = 1'b0;
            $display("Test %0d: Maximum A - A=%d, B=%d, C_in=%b", test_num, A, B, C_in);
            #1;

            check_outputs(4'hf);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 4'd8;
            B = 4'd8;
            C_in = 1'b0;
            $display("Test %0d: Overflow (Result 16) - A=%d, B=%d, C_in=%b", test_num, A, B, C_in);

            #1;


            check_outputs(4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 4'hf;
            B = 4'hf;
            C_in = 1'b1;
            $display("Test %0d: Maximum possible sum (31) - A=%d, B=%d, C_in=%b", test_num, A, B, C_in);

            #1;


            check_outputs(4'hf);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 4'ha;
            B = 4'h5;
            C_in = 1'b0;
            $display("Test %0d: Bit pattern 1010 + 0101 - A=%h, B=%h, C_in=%b", test_num, A, B, C_in);
            #1;

            check_outputs(4'hf);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = 4'b0110;
            B = 4'b1001;
            C_in = 1'b1;
            $display("Test %0d: Wrap to zero with C_in - A=%d, B=%d, C_in=%b", test_num, A, B, C_in);

            #1;


            check_outputs(4'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            A = 4'd12;
            B = 4'd7;
            C_in = 1'b0;
            $display("Test %0d: Mid-range overflow - A=%d, B=%d, C_in=%b", test_num, A, B, C_in);

            #1;


            check_outputs(4'd3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_adder Testbench");
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
        input [3:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: S=%h",
                         S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h",
                         expected_S);
                $display("  Got:      S=%h",
                         S);
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
