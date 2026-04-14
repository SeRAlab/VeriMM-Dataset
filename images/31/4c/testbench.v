`timescale 1ns/1ps

module brent_kung_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [4:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    brent_kung_adder dut (
        .A(A),
        .B(B),
        .S(S)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 4'd0; B = 4'd0;
        #10;
        $display("Test %0d: Zero Addition (0 + 0)", test_num);
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'hF; B = 4'hF;
        #10;
        $display("Test %0d: Maximum Values (15 + 15)", test_num);
        #1;

        check_outputs(5'd30);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 4'hF; B = 4'h1;
        #10;
        $display("Test %0d: Carry Out Boundary (15 + 1)", test_num);
        #1;

        check_outputs(5'h10);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 4'h5; B = 4'hA;
        #10;
        $display("Test %0d: Alternating Bits (5 + 10)", test_num);
        #1;

        check_outputs(5'h0F);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 4'h8; B = 4'h8;
        #10;
        $display("Test %0d: Single Bit Carry-out (8 + 8)", test_num);
        #1;

        check_outputs(5'h10);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 4'h7; B = 4'h1;
        #10;
        $display("Test %0d: Internal Carry Propagate (7 + 1)", test_num);
        #1;

        check_outputs(5'h08);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 4'h3; B = 4'h4;
        #10;
        $display("Test %0d: Basic Addition (3 + 4)", test_num);
        #1;

        check_outputs(5'h07);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 4'h9; B = 4'h6;
        #10;
        $display("Test %0d: No Carry-out Max (9 + 6)", test_num);
        #1;

        check_outputs(5'h0F);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 4'hB; B = 4'h5;
        #10;
        $display("Test %0d: Addition with Carry (11 + 5)", test_num);
        #1;

        check_outputs(5'h10);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 4'hE; B = 4'h3;
        #10;
        $display("Test %0d: Addition with Carry (14 + 3)", test_num);
        #1;

        check_outputs(5'h11);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("brent_kung_adder Testbench");
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
        input [4:0] expected_S;
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
