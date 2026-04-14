`timescale 1ns/1ps

module path_cost_calculator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] G;
    reg [7:0] H;
    wire [8:0] F;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    path_cost_calculator dut (
        .G(G),
        .H(H),
        .F(F)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero Inputs", test_num);
        G = 8'd0;
        H = 8'd0;
        #1;

        check_outputs(9'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum Inputs (Carry Check)", test_num);
        G = 8'd255;
        H = 8'd255;
        #1;

        check_outputs(9'd510);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Power of Two Sum", test_num);
        G = 8'd128;
        H = 8'd128;
        #1;

        check_outputs(9'd256);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Minimum Values", test_num);
        G = 8'd1;
        H = 8'd1;
        #1;

        check_outputs(9'd2);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary Carry (G max, H min)", test_num);
        G = 8'd255;
        H = 8'd1;
        #1;

        check_outputs(9'd256);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Arbitrary Cost Calculation 1", test_num);
        G = 8'd45;
        H = 8'd123;
        #1;

        check_outputs(9'd168);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Arbitrary Cost Calculation 2", test_num);
        G = 8'd200;
        H = 8'd50;
        #1;

        check_outputs(9'd250);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bit Alternating Check", test_num);
        G = 8'hAA;
        H = 8'h55;
        #1;

        check_outputs(9'h0FF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("path_cost_calculator Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [8:0] expected_F;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_F === (expected_F ^ F ^ expected_F)) begin
                $display("PASS");
                $display("  Outputs: F=%h",
                         F);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: F=%h",
                         expected_F);
                $display("  Got:      F=%h",
                         F);
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
