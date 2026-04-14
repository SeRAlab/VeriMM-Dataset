`timescale 1ns/1ps

module four_bit_complement_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg S;
    wire [3:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    four_bit_complement dut (
        .A(A),
        .S(S),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 4'b0000; S = 1;
        $display("Testcase %0d: Bitwise complement of 4'b0000 (S=1)", test_num);
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'b1111; S = 1;
        $display("Testcase %0d: Bitwise complement of 4'b1111 (S=1)", test_num);
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 4'b1010; S = 1;
        $display("Testcase %0d: Bitwise complement of 4'b1010 (S=1)", test_num);
        #1;

        check_outputs(4'b0101);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 4'b0101; S = 1;
        $display("Testcase %0d: Bitwise complement of 4'b0101 (S=1)", test_num);
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 4'b0000; S = 0;
        $display("Testcase %0d: 2's complement of 4'b0000 (S=0)", test_num);
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 4'b0001; S = 0;
        $display("Testcase %0d: 2's complement of 4'b0001 (S=0)", test_num);
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 4'b1111; S = 0;
        $display("Testcase %0d: 2's complement of 4'b1111 (S=0)", test_num);
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 4'b1000; S = 0;
        $display("Testcase %0d: 2's complement of 4'b1000 (S=0, min value)", test_num);
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 4'b0111; S = 0;
        $display("Testcase %0d: 2's complement of 4'b0111 (S=0, max positive)", test_num);
        #1;

        check_outputs(4'b1001);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 4'b1100; S = 0;
        $display("Testcase %0d: 2's complement of 4'b1100 (S=0)", test_num);
        #1;

        check_outputs(4'b0100);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("four_bit_complement Testbench");
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
        input [3:0] expected_Y;
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
