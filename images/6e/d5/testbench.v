`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] ain;
    reg [4:0] bin;
    reg rotate;
    reg sra;
    wire [15:0] yout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ain(ain),
        .bin(bin),
        .rotate(rotate),
        .sra(sra),
        .yout(yout)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        ain = 16'hABCD; bin = 5'd4; rotate = 0; sra = 0;
        #1;

        check_outputs(16'h0ABC);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        ain = 16'h8000; bin = 5'd4; rotate = 0; sra = 1;
        #1;

        check_outputs(16'hF800);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        ain = 16'h7000; bin = 5'd4; rotate = 0; sra = 1;
        #1;

        check_outputs(16'h0700);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        ain = 16'h000F; bin = 5'd4; rotate = 1; sra = 0;
        #1;

        check_outputs(16'hF000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        ain = 16'hABCD; bin = 5'h14; rotate = 0; sra = 0;
        #1;

        check_outputs(16'hBCD0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        ain = 16'h8001; bin = 5'h11; rotate = 1; sra = 0;
        #1;

        check_outputs(16'h0003);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        ain = 16'h1234; bin = 5'd0; rotate = 0; sra = 0;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        ain = 16'h1234; bin = 5'h10; rotate = 0; sra = 0;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        ain = 16'hFFFF; bin = 5'd15; rotate = 0; sra = 0;
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        ain = 16'h0001; bin = 5'h1F; rotate = 0; sra = 0;
        #1;

        check_outputs(16'h8000);
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
        input [15:0] expected_yout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_yout === (expected_yout ^ yout ^ expected_yout)) begin
                $display("PASS");
                $display("  Outputs: yout=%h",
                         yout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: yout=%h",
                         expected_yout);
                $display("  Got:      yout=%h",
                         yout);
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
