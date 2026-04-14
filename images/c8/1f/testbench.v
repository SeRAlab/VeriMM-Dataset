`timescale 1ns/1ps

module concat_shift_left_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [15:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    concat_shift_left dut (
        .A(A),
        .B(B),
        .C(C)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        A = 8'h12;
        B = 8'h34;
        $display("Testcase %0d: Input A=%h, B=%h", test_num, A, B);
        #1;

        check_outputs(16'h3412);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        A = 8'h00;
        B = 8'h00;
        $display("Testcase %0d: Zero Inputs - A=%h, B=%h", test_num, A, B);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        A = 8'hFF;
        B = 8'hFF;
        $display("Testcase %0d: All-Ones Inputs - A=%h, B=%h", test_num, A, B);
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        A = 8'hAA;
        B = 8'h55;
        $display("Testcase %0d: Alternating Bits - A=%h, B=%h", test_num, A, B);
        #1;

        check_outputs(16'h55AA);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        A = 8'h0F;
        B = 8'hF0;
        $display("Testcase %0d: Nibble Swap Pattern - A=%h, B=%h", test_num, A, B);
        #1;

        check_outputs(16'hF00F);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        A = 8'h81;
        B = 8'h7E;
        $display("Testcase %0d: Random Pattern - A=%h, B=%h", test_num, A, B);
        #1;

        check_outputs(16'h7E81);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("concat_shift_left Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [15:0] expected_C;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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
