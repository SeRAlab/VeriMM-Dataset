`timescale 1ns/1ps

module float_mult_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    wire [31:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    float_mult dut (
        .A(A),
        .B(B),
        .P(P)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: 1.0 * 1.0", test_num);
        A = 32'h3f800000;
        B = 32'h3f800000;
        #1;

        check_outputs(32'h3f800000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: 2.0 * 2.0", test_num);
        A = 32'h40000000;
        B = 32'h40000000;
        #1;

        check_outputs(32'h40800000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: 1.5 * 2.5", test_num);
        A = 32'h3fc00000;
        B = 32'h40200000;
        #1;

        check_outputs(32'h40700000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: -2.0 * 4.0", test_num);
        A = 32'hc0000000;
        B = 32'h40800000;
        #1;

        check_outputs(32'hc1000000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: 0.0 * 5.0", test_num);
        A = 32'h00000000;
        B = 32'h40a00000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: 0.5 * 0.5", test_num);
        A = 32'h3f000000;
        B = 32'h3f000000;
        #1;

        check_outputs(32'h3e800000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Inf * 1.0", test_num);
        A = 32'h7f800000;
        B = 32'h3f800000;
        #1;

        check_outputs(32'h7f800000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: -Inf * 1.0", test_num);
        A = 32'hff800000;
        B = 32'h3f800000;
        #1;

        check_outputs(32'hff800000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: -1.0 * -1.0", test_num);
        A = 32'hbf800000;
        B = 32'hbf800000;
        #1;

        check_outputs(32'h3f800000);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: NaN * 1.0", test_num);
        A = 32'h7fc00000;
        B = 32'h3f800000;


        #1;
        if (P[30:23] == 8'hFF && P[22:0] != 0) begin
            $display("PASS (Result is NaN)");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL (Expected NaN, Got %h)", P);
            fail_count = fail_count + 1;
        end
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("float_mult Testbench");
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
        input [31:0] expected_P;
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
