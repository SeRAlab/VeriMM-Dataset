`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] din;
    reg enable;
    wire [2:0] dout;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din(din),
        .enable(enable),
        .dout(dout),
        .valid(valid)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Disabled, All inputs high", test_num);
            enable = 0;
            din = 8'hFF;
            #10;

            #1;


            check_outputs(3'b000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enabled, No inputs high", test_num);
            enable = 1;
            din = 8'h00;
            #10;

            #1;


            check_outputs(3'b000, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enabled, Bit 0 high", test_num);
            enable = 1;
            din = 8'h01;
            #10;
            #1;

            check_outputs(3'd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enabled, Bit 1 high", test_num);
            enable = 1;
            din = 8'h02;
            #10;
            #1;

            check_outputs(3'd1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enabled, Bit 2 high", test_num);
            enable = 1;
            din = 8'h04;
            #10;
            #1;

            check_outputs(3'd2, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enabled, Bit 3 high", test_num);
            enable = 1;
            din = 8'h08;
            #10;
            #1;

            check_outputs(3'd3, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enabled, Bit 4 high", test_num);
            enable = 1;
            din = 8'h10;
            #10;
            #1;

            check_outputs(3'd4, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enabled, Bit 5 high", test_num);
            enable = 1;
            din = 8'h20;
            #10;
            #1;

            check_outputs(3'd5, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enabled, Bit 6 high", test_num);
            enable = 1;
            din = 8'h40;
            #10;
            #1;

            check_outputs(3'd6, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enabled, Bit 7 high", test_num);
            enable = 1;
            din = 8'h80;
            #10;
            #1;

            check_outputs(3'd7, 1'b1);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Priority Check - Bit 7 and Bit 0 high", test_num);
            enable = 1;
            din = 8'h81;
            #10;

            #1;


            check_outputs(3'd7, 1'b1);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Priority Check - Bits 4, 3, 2 high", test_num);
            enable = 1;
            din = 8'h1C;
            #10;
            #1;

            check_outputs(3'd4, 1'b1);
        end
        endtask

    task testcase013;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Bits high", test_num);
            enable = 1;
            din = 8'hFF;
            #10;
            #1;

            check_outputs(3'd7, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        testcase013();
        
        
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
        input [2:0] expected_dout;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, valid=%b",
                         dout, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, valid=%b",
                         expected_dout, expected_valid);
                $display("  Got:      dout=%h, valid=%b",
                         dout, valid);
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
