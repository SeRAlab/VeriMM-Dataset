`timescale 1ns/1ps

module brent_kung_adder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire Cout;
    wire [7:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    brent_kung_adder dut (
        .A(A),
        .B(B),
        .Cout(Cout),
        .S(S)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 8'h00; B = 8'h00;
            $display("Test %0d: Zero addition: A=%h, B=%h", test_num, A, B);
            #1;

            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 8'h05; B = 8'h0A;
            $display("Test %0d: Basic addition: A=%h, B=%h", test_num, A, B);
            #1;

            check_outputs(1'b0, 8'h0F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 8'hFF; B = 8'h00;
            $display("Test %0d: Maximum A + Zero: A=%h, B=%h", test_num, A, B);
            #1;

            check_outputs(1'b0, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 8'hFF; B = 8'h01;
            $display("Test %0d: Carry out check (255+1): A=%h, B=%h", test_num, A, B);
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 8'hFF; B = 8'hFF;
            $display("Test %0d: Maximum values: A=%h, B=%h", test_num, A, B);
            #1;

            check_outputs(1'b1, 8'hFE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 8'hAA; B = 8'h55;
            $display("Test %0d: Alternating bits: A=%h, B=%h", test_num, A, B);
            #1;

            check_outputs(1'b0, 8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 8'h80; B = 8'h80;
            $display("Test %0d: MSB Carry: A=%h, B=%h", test_num, A, B);
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 8'h12; B = 8'h34;
            $display("Test %0d: Random small numbers: A=%h, B=%h", test_num, A, B);
            #1;

            check_outputs(1'b0, 8'h46);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = 8'h7F; B = 8'h01;
            $display("Test %0d: Internal carry propagation: A=%h, B=%h", test_num, A, B);
            #1;

            check_outputs(1'b0, 8'h80);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            A = 8'hCC; B = 8'h33;
            $display("Test %0d: Full sum (no carry out): A=%h, B=%h", test_num, A, B);
            #1;

            check_outputs(1'b0, 8'hFF);
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
        input expected_Cout;
        input [7:0] expected_S;
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
