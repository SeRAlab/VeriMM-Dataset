`timescale 1ns/1ps

module adder_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [31:0] C;
    reg [31:0] D;
    wire [31:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 32'd0;
            B = 32'd0;
            C = 32'd0;
            D = 32'd0;
            $display("Test %0d: All inputs are zero", test_num);
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 32'd10;
            B = 32'd20;
            C = 32'd30;
            D = 32'd40;
            $display("Test %0d: Small positive integers", test_num);
            #1;

            check_outputs(32'd100);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 32'hFFFFFFFF;
            B = 32'd1;
            C = 32'd0;
            D = 32'd0;
            $display("Test %0d: Single overflow (A+B)", test_num);

            #1;


            check_outputs(32'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 32'h12345678;
            B = 32'h87654321;
            C = 32'h11111111;
            D = 32'h22222222;
            $display("Test %0d: Large hexadecimal values", test_num);
            #1;

            check_outputs(32'hCCDCCCCC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 32'd1000;
            B = 32'd1000;
            C = 32'd1000;
            D = 32'd1000;
            $display("Test %0d: All inputs equal", test_num);
            #1;

            check_outputs(32'd4000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 32'h7FFFFFFF;
            B = 32'h7FFFFFFF;
            C = 32'h0;
            D = 32'h2;
            $display("Test %0d: Multi-input accumulation near boundary", test_num);

            #1;


            check_outputs(32'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 32'd5;
            B = 32'd0;
            C = 32'd0;
            D = 32'd5;
            $display("Test %0d: Some zeros, some values", test_num);
            #1;

            check_outputs(32'd10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [31:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
