`timescale 1ns/1ps

module conv_3x3_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [24:0] image;
    reg [8:0] kernel;
    wire [7:0] result;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    conv_3x3 dut (
        .enable(enable),
        .image(image),
        .kernel(kernel),
        .result(result),
        .valid(valid)
    );
    task testcase001;

        begin
            $display("Running Testcase 001: All zeros");
            test_num = test_num + 1;
            enable = 1'b1;
            image = 25'h0;
            kernel = 9'h0;
            #1;

            check_outputs(8'd0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: All ones");
            test_num = test_num + 1;
            enable = 1'b1;
            image = 25'h1FFFFFF;
            kernel = 9'h1FF;

            #1;


            check_outputs(8'd9, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Enable Low Test");
            test_num = test_num + 1;
            enable = 1'b0;
            image = 25'h1FFFFFF;
            kernel = 9'h1FF;
            #1;

            check_outputs(result, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Single Center Pixel Match");
            test_num = test_num + 1;
            enable = 1'b1;
            image = (25'b1 << 12);
            kernel = (9'b1 << 4);
            #1;

            check_outputs(8'd1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Boundary Margin Test");
            test_num = test_num + 1;
            enable = 1'b1;
            image = 25'h1;
            kernel = 9'h1FF;

            #1;


            check_outputs(8'd0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Pattern Match");
            test_num = test_num + 1;
            enable = 1'b1;
            image = (1<<6) | (1<<8) | (1<<12) | (1<<16) | (1<<18);
            kernel = 9'b101_010_101;

            #1;


            check_outputs(8'd5, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: Kernel All Zeros mismatch");
            test_num = test_num + 1;
            enable = 1'b1;
            image = 25'h739C0;
            kernel = 9'h0;
            #1;

            check_outputs(8'd0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("conv_3x3 Testbench");
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
        input [7:0] expected_result;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: result=%h, valid=%b",
                         result, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, valid=%b",
                         expected_result, expected_valid);
                $display("  Got:      result=%h, valid=%b",
                         result, valid);
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
