`timescale 1ns/1ps

module adder_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg Cin;
    wire Cout;
    wire [15:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_16bit dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Cout(Cout),
        .S(S)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Addition (10 + 20)", test_num);
            A = 16'd10;
            B = 16'd20;
            Cin = 1'b0;
            #1;

            check_outputs(1'b0, 16'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition with Cin (100 + 200 + 1)", test_num);
            A = 16'd100;
            B = 16'd200;
            Cin = 1'b1;
            #1;

            check_outputs(1'b0, 16'd301);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Addition (0 + 0 + 0)", test_num);
            A = 16'h0000;
            B = 16'h0000;
            Cin = 1'b0;
            #1;

            check_outputs(1'b0, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max Sum No Cout (0xFFFE + 1)", test_num);
            A = 16'hFFFE;
            B = 16'h0001;
            Cin = 1'b0;
            #1;

            check_outputs(1'b0, 16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Carry-out via A+B (0xFFFF + 1)", test_num);
            A = 16'hFFFF;
            B = 16'h0001;
            Cin = 1'b0;
            #1;

            check_outputs(1'b1, 16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Carry-out via Cin (0xFFFF + 0 + 1)", test_num);
            A = 16'hFFFF;
            B = 16'h0000;
            Cin = 1'b1;
            #1;

            check_outputs(1'b1, 16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max values (0xFFFF + 0xFFFF + 1)", test_num);
            A = 16'hFFFF;
            B = 16'hFFFF;
            Cin = 1'b1;
            #1;

            check_outputs(1'b1, 16'hFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Middle range (0x1234 + 0xABCD)", test_num);
            A = 16'h1234;
            B = 16'hABCD;
            Cin = 1'b0;
            #1;

            check_outputs(1'b0, 16'hBE01);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating Bits (0xAAAA + 0x5555 + 1)", test_num);
            A = 16'hAAAA;
            B = 16'h5555;
            Cin = 1'b1;
            #1;

            check_outputs(1'b1, 16'h0000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Symmetric overflow (0x8000 + 0x8000)", test_num);
            A = 16'h8000;
            B = 16'h8000;
            Cin = 1'b0;
            #1;

            check_outputs(1'b1, 16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_16bit Testbench");
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
        input expected_Cout;
        input [15:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, S=%h",
                         Cout, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, S=%h",
                         expected_Cout, expected_S);
                $display("  Got:      Cout=%b, S=%h",
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
