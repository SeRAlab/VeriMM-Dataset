`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] IN;
    wire [16:0] OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IN(IN),
        .OUT(OUT)
    );
    task testcase000;

    begin
        test_num = test_num + 1;
        IN = 12'h000;
        #1;

        check_outputs(17'h00000);
    end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        IN = 12'hFFF;
        #1;

        check_outputs(17'h1FFFE);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        IN = 12'h001;
        #1;

        check_outputs(17'h00007);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        IN = 12'h800;
        #1;

        check_outputs(17'h18001);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        IN = 12'hA5A;
        #1;

        check_outputs(17'h1A5DB);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        IN = 12'h5A5;
        #1;

        check_outputs(17'h05A25);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        IN = 12'h123;
        #1;

        check_outputs(17'h01215);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        IN = 12'hF0F;
        #1;

        check_outputs(17'h1F0F6);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        IN = 12'h002;
        #1;

        check_outputs(17'h00019);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        IN = 12'h400;
        #1;

        check_outputs(17'h0408B);
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


        testcase000();
        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input [16:0] expected_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OUT === (expected_OUT ^ OUT ^ expected_OUT)) begin
                $display("PASS");
                $display("  Outputs: OUT=%h",
                         OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT=%h",
                         expected_OUT);
                $display("  Got:      OUT=%h",
                         OUT);
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
