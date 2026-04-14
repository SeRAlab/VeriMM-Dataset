`timescale 1ns/1ps

module booth_multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [7:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    booth_multiplier dut (
        .A(A),
        .B(B),
        .P(P)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 4'd3; B = 4'd2;
        $display("Test Case %0d: A=%d, B=%d", test_num, $signed(A), $signed(B));
        #1;

        check_outputs(8'h06);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'd3; B = -4'd2;
        $display("Test Case %0d: A=%d, B=%d", test_num, $signed(A), $signed(B));
        #1;

        check_outputs(8'hFA);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = -4'd3; B = 4'd2;
        $display("Test Case %0d: A=%d, B=%d", test_num, $signed(A), $signed(B));
        #1;

        check_outputs(8'hFA);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = -4'd3; B = -4'd2;
        $display("Test Case %0d: A=%d, B=%d", test_num, $signed(A), $signed(B));
        #1;

        check_outputs(8'h06);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 4'd0; B = 4'd5;
        $display("Test Case %0d: A=%d, B=%d", test_num, $signed(A), $signed(B));
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = -4'd7; B = 4'd0;
        $display("Test Case %0d: A=%d, B=%d", test_num, $signed(A), $signed(B));
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 4'sb0111; B = 4'sb0111;
        $display("Test Case %0d: A=%d, B=%d", test_num, $signed(A), $signed(B));
        #1;

        check_outputs(8'h31);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 4'sb1000; B = 4'sb1000;
        $display("Test Case %0d: A=%d, B=%d", test_num, $signed(A), $signed(B));
        #1;

        check_outputs(8'h40);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 4'sb0111; B = 4'sb1000;
        $display("Test Case %0d: A=%d, B=%d", test_num, $signed(A), $signed(B));
        #1;

        check_outputs(8'hC8);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = -4'd1; B = 4'd5;
        $display("Test Case %0d: A=%d, B=%d", test_num, $signed(A), $signed(B));
        #1;

        check_outputs(8'hFB);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("booth_multiplier Testbench");
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
        input [7:0] expected_P;
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
