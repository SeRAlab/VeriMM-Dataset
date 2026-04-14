`timescale 1ns/1ps

module csa_4bit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    wire [3:0] Cout;
    wire [4:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    csa_4bit dut (
        .A(A),
        .B(B),
        .C(C),
        .Cout(Cout),
        .S(S)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs zero", test_num);
            A = 4'b0000; B = 4'b0000; C = 4'b0000;
            #1;

            check_outputs(4'h0, 5'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single bit set (no carries)", test_num);
            A = 4'b0001; B = 4'b0010; C = 4'b0100;

            #1;


            check_outputs(4'h0, 5'h07);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All bits set in A, others zero", test_num);
            A = 4'b1111; B = 4'b0000; C = 4'b0000;

            #1;


            check_outputs(4'h0, 5'h0F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs same (Full overlap)", test_num);
            A = 4'b1111; B = 4'b1111; C = 4'b1111;


            #1;



            check_outputs(4'hF, 5'h0F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Two inputs same, one zero", test_num);
            A = 4'b1010; B = 4'b1010; C = 4'b0000;



            #1;




            check_outputs(4'hA, 5'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed bits with carries", test_num);
            A = 4'b0111; B = 4'b0011; C = 4'b0001;





            #1;






            check_outputs(4'h3, 5'h05);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bit patterns", test_num);
            A = 4'b1010; B = 4'b0101; C = 4'b1111;





            #1;






            check_outputs(4'hF, 5'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum magnitude sum check", test_num);
            A = 4'hE; B = 4'hE; C = 4'hE;



            #1;




            check_outputs(4'hE, 5'h0E);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("csa_4bit Testbench");
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
        input [3:0] expected_Cout;
        input [4:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: Cout=%h, S=%h",
                         Cout, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%h, S=%h",
                         expected_Cout, expected_S);
                $display("  Got:      Cout=%h, S=%h",
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
