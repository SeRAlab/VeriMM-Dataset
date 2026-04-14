`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [31:0] C;
    wire [31:0] X;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .X(X)
    );
    task testcase001;

    begin
        A = 32'h0; B = 32'h0; C = 32'h0;
        #1;

        check_outputs(32'h0);
    end
        endtask

    task testcase002;

    begin
        A = 32'd1000; B = 32'd500; C = 32'd250;
        #1;

        check_outputs(32'd1000);
    end
        endtask

    task testcase003;

    begin
        A = 32'd500; B = 32'd1000; C = 32'd250;
        #1;

        check_outputs(32'd1000);
    end
        endtask

    task testcase004;

    begin
        A = 32'd500; B = 32'd250; C = 32'd1000;
        #1;

        check_outputs(32'd1000);
    end
        endtask

    task testcase005;

    begin
        A = 32'hFFFF_FFFF; B = 32'hFFFF_FFFF; C = 32'hFFFF_FFFF;
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase006;

    begin
        A = 32'd2000; B = 32'd2000; C = 32'd1500;
        #1;

        check_outputs(32'd2000);
    end
        endtask

    task testcase007;

    begin
        A = 32'd2000; B = 32'd1500; C = 32'd2000;
        #1;

        check_outputs(32'd2000);
    end
        endtask

    task testcase008;

    begin
        A = 32'd1500; B = 32'd2000; C = 32'd2000;
        #1;

        check_outputs(32'd2000);
    end
        endtask

    task testcase009;

    begin
        A = 32'h0000_0001; B = 32'h8000_0000; C = 32'h7FFF_FFFF;
        #1;

        check_outputs(32'h8000_0000);
    end
        endtask

    task testcase010;

    begin
        A = 32'd12345; B = 32'd67890; C = 32'd54321;
        #1;

        check_outputs(32'd67890);
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
        input [31:0] expected_X;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_X === (expected_X ^ X ^ expected_X)) begin
                $display("PASS");
                $display("  Outputs: X=%h",
                         X);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X=%h",
                         expected_X);
                $display("  Got:      X=%h",
                         X);
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
