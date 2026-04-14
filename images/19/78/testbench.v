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
            test_num = 1;
            $display("Testcase %0d: 0 * 0", test_num);
            A = 8'd0;
            B = 8'd0;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Max * 0", test_num);
            A = 8'd255;
            B = 8'd0;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: 0 * Max", test_num);
            A = 8'd0;
            B = 8'd255;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: 1 * 1", test_num);
            A = 8'd1;
            B = 8'd1;
            #1;

            check_outputs(16'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Max * Max", test_num);
            A = 8'd255;
            B = 8'd255;
            #1;

            check_outputs(16'hFE01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Power of 2 (16 * 16)", test_num);
            A = 8'd16;
            B = 8'd16;
            #1;

            check_outputs(16'd256);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: 123 * 45", test_num);
            A = 8'd123;
            B = 8'd45;
            #1;

            check_outputs(16'd5535);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: 15 * 15", test_num);
            A = 8'd15;
            B = 8'd15;
            #1;

            check_outputs(16'd225);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Alternating Bits (0xAA * 0x55)", test_num);
            A = 8'hAA;
            B = 8'h55;
            #1;

            check_outputs(16'h3872);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Large range (2 * 255)", test_num);
            A = 8'd2;
            B = 8'd255;
            #1;

            check_outputs(16'd510);
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
