`timescale 1ns/1ps

module and_gate_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] x;
    reg [3:0] z;
    wire [3:0] w;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    and_gate dut (
        .x(x),
        .z(z),
        .w(w)
    );
    task testcase001;

    begin
        test_num = 1;
        x = 4'b0000;
        z = 4'b0000;
        $display("Test %0d: All Zeros", test_num);
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        x = 4'b1111;
        z = 4'b1111;
        $display("Test %0d: All Ones", test_num);
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        x = 4'b1010;
        z = 4'b0101;
        $display("Test %0d: Complementary Bit Patterns", test_num);
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        x = 4'b1100;
        z = 4'b1010;
        $display("Test %0d: Partial Overlap 1 (C & A)", test_num);
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        x = 4'b0111;
        z = 4'b1101;
        $display("Test %0d: Partial Overlap 2 (7 & D)", test_num);
        #1;

        check_outputs(4'b0101);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        x = 4'b1111;
        z = 4'b0011;
        $display("Test %0d: Identity Masking (F & 3)", test_num);
        #1;

        check_outputs(4'b0011);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        x = 4'b1011;
        z = 4'b1110;
        $display("Test %0d: Mixed Bits (B & E)", test_num);
        #1;

        check_outputs(4'b1010);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("and_gate Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [3:0] expected_w;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_w === (expected_w ^ w ^ expected_w)) begin
                $display("PASS");
                $display("  Outputs: w=%h",
                         w);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: w=%h",
                         expected_w);
                $display("  Got:      w=%h",
                         w);
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
