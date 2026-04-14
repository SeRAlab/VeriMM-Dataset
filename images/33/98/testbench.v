`timescale 1ns/1ps

module bitwise_and_equal_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [7:0] C;
    wire equal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bitwise_and_equal dut (
        .A(A),
        .B(B),
        .C(C),
        .equal(equal)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Simple bitwise AND, not equal", test_num);
        A = 8'b10101010;
        B = 8'b11001100;

        #1;


        check_outputs(8'h88, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Both inputs all zeros (equal)", test_num);
        A = 8'h00;
        B = 8'h00;

        #1;


        check_outputs(8'h00, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Both inputs all ones (equal)", test_num);
        A = 8'hFF;
        B = 8'hFF;

        #1;


        check_outputs(8'hFF, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Complementary bits (non-equal)", test_num);
        A = 8'hAA;
        B = 8'h55;

        #1;


        check_outputs(8'h00, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Equal non-zero values", test_num);
        A = 8'hA5;
        B = 8'hA5;

        #1;


        check_outputs(8'hA5, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: One bit difference (non-equal)", test_num);
        A = 8'hF0;
        B = 8'hF1;

        #1;


        check_outputs(8'hF0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Masking high nibble", test_num);
        A = 8'hF0;
        B = 8'h0F;

        #1;


        check_outputs(8'h00, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Complex bit pattern", test_num);
        A = 8'hBD;
        B = 8'h9E;

        #1;


        check_outputs(8'h9C, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bitwise_and_equal Testbench");
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
        input [7:0] expected_C;
        input expected_equal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_equal === (expected_equal ^ equal ^ expected_equal)) begin
                $display("PASS");
                $display("  Outputs: C=%h, equal=%b",
                         C, equal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h, equal=%b",
                         expected_C, expected_equal);
                $display("  Got:      C=%h, equal=%b",
                         C, equal);
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
