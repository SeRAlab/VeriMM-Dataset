`timescale 1ns/1ps

module csa_4bit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    wire [3:0] Cout;
    wire [3:0] S;

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
        $display("Test %0d: All Zeros", test_num);
        A = 4'h0; B = 4'h0; C = 4'h0;
        #1;

        check_outputs(4'h0, 4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Ones", test_num);
        A = 4'hF; B = 4'hF; C = 4'hF;
        #1;

        check_outputs(4'hF, 4'hF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Single Bits No Overlap", test_num);
        A = 4'b0001; B = 4'b0010; C = 4'b0100;
        #1;

        check_outputs(4'h0, 4'h7);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bit Overlap Leading to Carry", test_num);
        A = 4'b0101; B = 4'b1010; C = 4'b0011;




        #1;





        check_outputs(4'b0011, 4'b1100);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximize Carry Generation", test_num);
        A = 4'b1110; B = 4'b0111; C = 4'b1011;




        #1;





        check_outputs(4'b1111, 4'b0010);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating Patterns", test_num);
        A = 4'hA; B = 4'h5; C = 4'hA;



        #1;




        check_outputs(4'hA, 4'h5);
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
        input [3:0] expected_S;
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
