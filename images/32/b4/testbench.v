`timescale 1ns/1ps

module CSA_3input_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] A;
    reg [4:0] B;
    reg [4:0] C;
    wire [5:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    CSA_3input dut (
        .A(A),
        .B(B),
        .C(C),
        .SUM(SUM)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All zeros", test_num);
            A = 5'd0;
            B = 5'd0;
            C = 5'd0;
            #1;

            check_outputs(6'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Small individual values", test_num);
            A = 5'd1;
            B = 5'd2;
            C = 5'd3;
            #1;

            check_outputs(6'd6);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: One input at max 5-bit value", test_num);
            A = 5'd31;
            B = 5'd0;
            C = 5'd0;
            #1;

            check_outputs(6'd31);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Medium values sum to 32 (boundary)", test_num);
            A = 5'd10;
            B = 5'd11;
            C = 5'd11;
            #1;

            check_outputs(6'd32);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum sum within 6-bit range (63)", test_num);
            A = 5'd21;
            B = 5'd21;
            C = 5'd21;
            #1;

            check_outputs(6'd63);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overflow check (sum > 63, should truncate to 6 bits)", test_num);

            A = 5'd31;
            B = 5'd31;
            C = 5'd31;
            #1;

            check_outputs(6'd29);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Another overflow check", test_num);

            A = 5'd20;
            B = 5'd25;
            C = 5'd30;
            #1;

            check_outputs(6'd11);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random pattern 1", test_num);
            A = 5'b10101;
            B = 5'b01010;
            C = 5'b00111;
            #1;

            check_outputs(6'd38);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random pattern 2", test_num);
            A = 5'b11110;
            B = 5'b00001;
            C = 5'b01111;
            #1;

            check_outputs(6'd46);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating bits", test_num);
            A = 5'b10101;
            B = 5'b01010;
            C = 5'b10101;
            #1;

            check_outputs(6'd52);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("CSA_3input Testbench");
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
        input [5:0] expected_SUM;
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
