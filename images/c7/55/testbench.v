`timescale 1ns/1ps

module mux_4to1_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    reg [3:0] D;
    reg [1:0] S;
    wire [3:0] OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_4to1 dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .S(S),
        .OUT(OUT)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Input A (S=2'b00)", test_num);
            A = 4'h1;
            B = 4'h2;
            C = 4'h4;
            D = 4'h8;
            S = 2'b00;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Input B (S=2'b01)", test_num);
            A = 4'h1;
            B = 4'h2;
            C = 4'h4;
            D = 4'h8;
            S = 2'b01;
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Input C (S=2'b10)", test_num);
            A = 4'h1;
            B = 4'h2;
            C = 4'h4;
            D = 4'h8;
            S = 2'b10;
            #1;

            check_outputs(4'h4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Input D (S=2'b11)", test_num);
            A = 4'h1;
            B = 4'h2;
            C = 4'h4;
            D = 4'h8;
            S = 2'b11;
            #1;

            check_outputs(4'h8);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs identical", test_num);
            A = 4'hF;
            B = 4'hF;
            C = 4'hF;
            D = 4'hF;
            S = 2'b10;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero inputs", test_num);
            A = 4'h0;
            B = 4'h0;
            C = 4'h0;
            D = 4'h0;
            S = 2'b00;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits pattern", test_num);
            A = 4'hA;
            B = 4'h5;
            C = 4'h3;
            D = 4'hC;
            S = 2'b01;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify non-selected input change has no effect", test_num);
            A = 4'h7;
            B = 4'h3;
            C = 4'hE;
            D = 4'h1;
            S = 2'b00;
            #5;
            B = 4'hF;
            C = 4'h0;
            D = 4'hA;
            #1;

            check_outputs(4'h7);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_4to1 Testbench");
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
        input [3:0] expected_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OUT === (expected_OUT ^ OUT ^ expected_OUT)) begin
                $display("PASS");
                $display("  Outputs: OUT=%h",
                         OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT=%h",
                         expected_OUT);
                $display("  Got:      OUT=%h",
                         OUT);
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
