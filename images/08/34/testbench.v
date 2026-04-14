`timescale 1ns/1ps

module portfolio_optimizer_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] return_A;
    reg [15:0] return_B;
    reg [15:0] return_C;
    reg [15:0] risk_A;
    reg [15:0] risk_B;
    reg [15:0] risk_C;
    wire [15:0] weight_A;
    wire [15:0] weight_B;
    wire [15:0] weight_C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    portfolio_optimizer dut (
        .return_A(return_A),
        .return_B(return_B),
        .return_C(return_C),
        .risk_A(risk_A),
        .risk_B(risk_B),
        .risk_C(risk_C),
        .weight_A(weight_A),
        .weight_B(weight_B),
        .weight_C(weight_C)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Uniform Assets", test_num);
            return_A = 16'h0100;
            return_B = 16'h0100;
            return_C = 16'h0100;
            risk_A   = 16'h0010;
            risk_B   = 16'h0010;
            risk_C   = 16'h0010;

            #1;


            check_outputs(16'h5555, 16'h5555, 16'h5555);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: High Return Asset A", test_num);
            return_A = 16'h0200;
            return_B = 16'h0100;
            return_C = 16'h0100;
            risk_A   = 16'h0010;
            risk_B   = 16'h0010;
            risk_C   = 16'h0010;

            #1;


            check_outputs(16'h8000, 16'h4000, 16'h4000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Low Risk Asset B", test_num);
            return_A = 16'h0100;
            return_B = 16'h0100;
            return_C = 16'h0100;
            risk_A   = 16'h0020;
            risk_B   = 16'h0010;
            risk_C   = 16'h0020;

            #1;


            check_outputs(16'h4000, 16'h8000, 16'h4000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero Return Asset C", test_num);
            return_A = 16'h0100;
            return_B = 16'h0100;
            return_C = 16'h0000;
            risk_A   = 16'h0010;
            risk_B   = 16'h0010;
            risk_C   = 16'h0010;

            #1;


            check_outputs(16'h8000, 16'h8000, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: High Risk Asset A", test_num);
            return_A = 16'h0100;
            return_B = 16'h0100;
            return_C = 16'h0100;
            risk_A   = 16'hFFFF;
            risk_B   = 16'h0010;
            risk_C   = 16'h0010;

            #1;


            check_outputs(16'h0000, 16'h8000, 16'h8000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mixed Ratios", test_num);
            return_A = 16'd100;
            risk_A   = 16'd10;
            return_B = 16'd200;
            risk_B   = 16'd10;
            return_C = 16'd100;
            risk_C   = 16'd5;

            #1;


            check_outputs(16'h3333, 16'h6666, 16'h6666);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("portfolio_optimizer Testbench");
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
        input [15:0] expected_weight_A;
        input [15:0] expected_weight_B;
        input [15:0] expected_weight_C;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_weight_A === (expected_weight_A ^ weight_A ^ expected_weight_A) &&
                expected_weight_B === (expected_weight_B ^ weight_B ^ expected_weight_B) &&
                expected_weight_C === (expected_weight_C ^ weight_C ^ expected_weight_C)) begin
                $display("PASS");
                $display("  Outputs: weight_A=%h, weight_B=%h, weight_C=%h",
                         weight_A, weight_B, weight_C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: weight_A=%h, weight_B=%h, weight_C=%h",
                         expected_weight_A, expected_weight_B, expected_weight_C);
                $display("  Got:      weight_A=%h, weight_B=%h, weight_C=%h",
                         weight_A, weight_B, weight_C);
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
