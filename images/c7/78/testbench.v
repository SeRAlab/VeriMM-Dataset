`timescale 1ns/1ps

module four_bit_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg Cin;
    wire [3:0] C;
    wire Cout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    four_bit_adder dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .C(C),
        .Cout(Cout)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 4'h0; B = 4'h0; Cin = 1'b0;
            $display("Test %0d: A=0, B=0, Cin=0", test_num);
            #1;

            check_outputs(4'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 4'h5; B = 4'h3; Cin = 1'b0;
            $display("Test %0d: A=5, B=3, Cin=0 (Basic addition)", test_num);
            #1;

            check_outputs(4'h8, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 4'h5; B = 4'h3; Cin = 1'b1;
            $display("Test %0d: A=5, B=3, Cin=1 (Addition with carry-in)", test_num);
            #1;

            check_outputs(4'h9, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 4'hF; B = 4'h1; Cin = 1'b0;
            $display("Test %0d: A=F, B=1, Cin=0 (Generate carry-out)", test_num);
            #1;

            check_outputs(4'h0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 4'h7; B = 4'h8; Cin = 1'b0;
            $display("Test %0d: A=7, B=8, Cin=0 (Sum to 15)", test_num);
            #1;

            check_outputs(4'hF, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 4'h7; B = 4'h8; Cin = 1'b1;
            $display("Test %0d: A=7, B=8, Cin=1 (Sum to 16/Carry)", test_num);
            #1;

            check_outputs(4'h0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 4'hA; B = 4'h5; Cin = 1'b0;
            $display("Test %0d: A=A, B=5, Cin=0", test_num);
            #1;

            check_outputs(4'hF, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 4'hF; B = 4'hF; Cin = 1'b1;
            $display("Test %0d: A=F, B=F, Cin=1 (Maximum possible value)", test_num);
            #1;

            check_outputs(4'hF, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("four_bit_adder Testbench");
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
        input [3:0] expected_C;
        input expected_Cout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_Cout === (expected_Cout ^ Cout ^ expected_Cout)) begin
                $display("PASS");
                $display("  Outputs: C=%h, Cout=%b",
                         C, Cout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h, Cout=%b",
                         expected_C, expected_Cout);
                $display("  Got:      C=%h, Cout=%b",
                         C, Cout);
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
