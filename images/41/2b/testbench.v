`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] Din;
    wire [31:0] Dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Din(Din),
        .Dout(Dout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            Din = 16'h0000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            Din = 16'h0009;
            #1;

            check_outputs(32'h00000009);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            Din = 16'h000A;
            #1;

            check_outputs(32'h00000010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            Din = 16'h000F;
            #1;

            check_outputs(32'h00000015);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            Din = 16'h0063;
            #1;

            check_outputs(32'h00000099);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            Din = 16'h0064;
            #1;

            check_outputs(32'h00000100);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            Din = 16'h03E7;
            #1;

            check_outputs(32'h00000999);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            Din = 16'h03E8;
            #1;

            check_outputs(32'h00001000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            Din = 16'h270F;
            #1;

            check_outputs(32'h00009999);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            Din = 16'hFFFF;
            #1;

            check_outputs(32'h00005535);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            Din = 16'h1234;
            #1;

            check_outputs(32'h00004660);
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
        input [31:0] expected_Dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Dout === (expected_Dout ^ Dout ^ expected_Dout)) begin
                $display("PASS");
                $display("  Outputs: Dout=%h",
                         Dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Dout=%h",
                         expected_Dout);
                $display("  Got:      Dout=%h",
                         Dout);
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
