`timescale 1ns/1ps

module multiplier_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    wire [31:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier_16bit dut (
        .A(A),
        .B(B),
        .P(P)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero multiplication (0 * 0)", test_num);
            A = 16'h0000;
            B = 16'h0000;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Identity multiplication (1234 * 1)", test_num);
            A = 16'h1234;
            B = 16'h0001;
            #1;

            check_outputs(32'h0000_1234);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiplication by zero (FFFF * 0)", test_num);
            A = 16'hFFFF;
            B = 16'h0000;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Small numbers (12 * 13)", test_num);
            A = 16'd12;
            B = 16'd13;
            #1;

            check_outputs(32'd156);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum values (FFFF * FFFF)", test_num);
            A = 16'hFFFF;
            B = 16'hFFFF;
            #1;

            check_outputs(32'hFFFE_0001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Power of 2 (256 * 256)", test_num);
            A = 16'h0100;
            B = 16'h0100;
            #1;

            check_outputs(32'h0001_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Arbitrary large values (AAAA * 5555)", test_num);
            A = 16'hAAAA;
            B = 16'h5555;
            #1;

            check_outputs(32'h38E3_1C72);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary value (8000 * 2)", test_num);
            A = 16'h8000;
            B = 16'h0002;
            #1;

            check_outputs(32'h0001_0000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Prime-like product (123 * 456)", test_num);
            A = 16'd123;
            B = 16'd456;
            #1;

            check_outputs(32'd56088);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: High bit and Low bit (8001 * 0001)", test_num);
            A = 16'h8001;
            B = 16'h0001;
            #1;

            check_outputs(32'h0000_8001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier_16bit Testbench");
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
        input [31:0] expected_P;
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
