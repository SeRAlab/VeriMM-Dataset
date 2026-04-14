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
            $display("Test %0d: Zero inputs (0 * 0)", test_num);
            A = 8'h00;
            B = 8'h00;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiply by zero (255 * 0)", test_num);
            A = 8'hFF;
            B = 8'h00;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero multiplied by value (0 * 255)", test_num);
            A = 8'h00;
            B = 8'hFF;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Unit multiplication (1 * 1)", test_num);
            A = 8'h01;
            B = 8'h01;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Identity property (255 * 1)", test_num);
            A = 8'hFF;
            B = 8'h01;
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum values (255 * 255)", test_num);
            A = 8'hFF;
            B = 8'hFF;
            #1;

            check_outputs(16'hFE01);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Power of 2 (16 * 16)", test_num);
            A = 8'd16;
            B = 8'd16;
            #1;

            check_outputs(16'h0100);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large result power of 2 (128 * 128)", test_num);
            A = 8'd128;
            B = 8'd128;
            #1;

            check_outputs(16'h4000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating bits (170 * 85)", test_num);
            A = 8'hAA;
            B = 8'h55;
            #1;

            check_outputs(16'h3872);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random values (123 * 45)", test_num);
            A = 8'd123;
            B = 8'd45;
            #1;

            check_outputs(16'h159F);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Small primes (13 * 17)", test_num);
            A = 8'd13;
            B = 8'd17;
            #1;

            check_outputs(16'h00DD);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Near overflow (254 * 255)", test_num);
            A = 8'd254;
            B = 8'd255;
            #1;

            check_outputs(16'hFD02);
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
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        
        
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
