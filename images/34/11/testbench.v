`timescale 1ns/1ps

module vector_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [4:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    vector_adder dut (
        .A(A),
        .B(B),
        .SUM(SUM)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 4'd0;
            B = 4'd0;
            $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 4'd5;
            B = 4'd3;
            $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(5'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 4'hF;
            B = 4'h0;
            $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 4'hF;
            B = 4'h1;
            $display("Testcase %0d: A=%d, B=%d (Carry bit test)", test_num, A, B);
            #1;

            check_outputs(5'd16);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 4'hF;
            B = 4'hF;
            $display("Testcase %0d: A=%d, B=%d (Max values)", test_num, A, B);
            #1;

            check_outputs(5'd30);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 4'd10;
            B = 4'd10;
            $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(5'd20);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 4'd7;
            B = 4'd8;
            $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 4'b1010;
            B = 4'b0101;
            $display("Testcase %0d: A=%b, B=%b", test_num, A, B);
            #1;

            check_outputs(5'd15);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("vector_adder Testbench");
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
        input [4:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: SUM=%h",
                         SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SUM=%h",
                         expected_SUM);
                $display("  Got:      SUM=%h",
                         SUM);
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
