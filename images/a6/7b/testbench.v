`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] in_data;
    wire [31:0] out_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_data(in_data),
        .out_data(out_data)
    );
    task testcase001;

    begin
        test_num = 1;
        in_data = 12'h000;
        #1;

        check_outputs(32'h00000200);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        in_data = 12'h1FF;
        #1;

        check_outputs(32'h000003FF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        in_data = 12'h200;
        #1;

        check_outputs(32'h00000400);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        in_data = 12'h3FF;
        #1;

        check_outputs(32'h000007FE);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        in_data = 12'h400;
        #1;

        check_outputs(32'h00000800);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        in_data = 12'h600;
        #1;

        check_outputs(32'h00001000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        in_data = 12'h880;
        #1;

        check_outputs(32'h00002800);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        in_data = 12'hA00;
        #1;

        check_outputs(32'h00004000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        in_data = 12'hC00;
        #1;

        check_outputs(32'h00008000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        in_data = 12'hE00;
        #1;

        check_outputs(32'h00010000);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        in_data = 12'hF00;
        #1;

        check_outputs(32'h00018000);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        in_data = 12'hFFF;
        #1;

        check_outputs(32'h0001FF80);
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
        input [31:0] expected_out_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_data === (expected_out_data ^ out_data ^ expected_out_data)) begin
                $display("PASS");
                $display("  Outputs: out_data=%h",
                         out_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_data=%h",
                         expected_out_data);
                $display("  Got:      out_data=%h",
                         out_data);
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
