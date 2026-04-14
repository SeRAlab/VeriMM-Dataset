`timescale 1ns/1ps

module sky130_fd_sc_hd__full_adder_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg Cin;
    wire Cout;
    wire S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sky130_fd_sc_hd__full_adder dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Cout(Cout),
        .S(S)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 1'b0; B = 1'b0; Cin = 1'b0;
            $display("Test %0d: A=%b, B=%b, Cin=%b", test_num, A, B, Cin);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 1'b0; B = 1'b0; Cin = 1'b1;
            $display("Test %0d: A=%b, B=%b, Cin=%b", test_num, A, B, Cin);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 1'b0; B = 1'b1; Cin = 1'b0;
            $display("Test %0d: A=%b, B=%b, Cin=%b", test_num, A, B, Cin);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 1'b0; B = 1'b1; Cin = 1'b1;
            $display("Test %0d: A=%b, B=%b, Cin=%b", test_num, A, B, Cin);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 1'b1; B = 1'b0; Cin = 1'b0;
            $display("Test %0d: A=%b, B=%b, Cin=%b", test_num, A, B, Cin);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 1'b1; B = 1'b0; Cin = 1'b1;
            $display("Test %0d: A=%b, B=%b, Cin=%b", test_num, A, B, Cin);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 1'b1; B = 1'b1; Cin = 1'b0;
            $display("Test %0d: A=%b, B=%b, Cin=%b", test_num, A, B, Cin);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 1'b1; B = 1'b1; Cin = 1'b1;
            $display("Test %0d: A=%b, B=%b, Cin=%b", test_num, A, B, Cin);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sky130_fd_sc_hd__full_adder Testbench");
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
        input expected_Cout;
        input expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, S=%b",
                         Cout, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, S=%b",
                         expected_Cout, expected_S);
                $display("  Got:      Cout=%b, S=%b",
                         Cout, S);
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
