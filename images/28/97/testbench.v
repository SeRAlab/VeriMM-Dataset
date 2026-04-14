`timescale 1ns/1ps

module multiplier_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [15:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier_8bit dut (
        .A(A),
        .B(B),
        .P(P)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication by Zero", test_num);
            A = 8'd0;
            B = 8'd0;
            #1;

            check_outputs(16'd0);

            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication by Zero (A=0)", test_num);
            A = 8'd0;
            B = 8'hFF;
            #1;

            check_outputs(16'd0);

            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication by Zero (B=0)", test_num);
            A = 8'hFF;
            B = 8'd0;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication by One", test_num);
            A = 8'd1;
            B = 8'd1;
            #1;

            check_outputs(16'd1);

            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication by One (Identity A)", test_num);
            A = 8'd1;
            B = 8'd127;
            #1;

            check_outputs(16'd127);

            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication by One (Identity B)", test_num);
            A = 8'd255;
            B = 8'd1;
            #1;

            check_outputs(16'd255);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum Values", test_num);
            A = 8'hFF;
            B = 8'hFF;

            #1;


            check_outputs(16'hFE01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Powers of Two", test_num);
            A = 8'd16;
            B = 8'd16;
            #1;

            check_outputs(16'd256);

            test_num = test_num + 1;
            $display("Testcase %0d: Power of Two shift-like", test_num);
            A = 8'd128;
            B = 8'd2;
            #1;

            check_outputs(16'd256);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random-like values (1)", test_num);
            A = 8'd12;
            B = 8'd12;
            #1;

            check_outputs(16'd144);

            test_num = test_num + 1;
            $display("Testcase %0d: Random-like values (2)", test_num);
            A = 8'd123;
            B = 8'd45;

            #1;


            check_outputs(16'h159F);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bit Patterns", test_num);
            A = 8'hAA;
            B = 8'h55;

            #1;


            check_outputs(16'h3872);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier_8bit Testbench");
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
        input [15:0] expected_P;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: P=%h",
                         P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h",
                         expected_P);
                $display("  Got:      P=%h",
                         P);
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
