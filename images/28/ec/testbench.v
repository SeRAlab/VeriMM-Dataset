`timescale 1ns/1ps

module portfolio_optimizer_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] return1;
    reg [4:0] return2;
    reg [4:0] return3;
    reg [4:0] weight1;
    reg [4:0] weight2;
    reg [4:0] weight3;
    wire [9:0] expected_return;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    portfolio_optimizer dut (
        .return1(return1),
        .return2(return2),
        .return3(return3),
        .weight1(weight1),
        .weight2(weight2),
        .weight3(weight3),
        .expected_return(expected_return)
    );
    task testcase001;

    begin
        test_num = 1;
        weight1 = 5'd0; return1 = 5'd0;
        weight2 = 5'd0; return2 = 5'd0;
        weight3 = 5'd0; return3 = 5'd0;

        #1;


        check_outputs(10'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        weight1 = 5'd1; return1 = 5'd1;
        weight2 = 5'd1; return2 = 5'd1;
        weight3 = 5'd1; return3 = 5'd1;

        #1;


        check_outputs(10'd3);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        weight1 = 5'd31; return1 = 5'd1;
        weight2 = 5'd31; return2 = 5'd1;
        weight3 = 5'd31; return3 = 5'd1;

        #1;


        check_outputs(10'd93);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        weight1 = 5'd10; return1 = 5'd20;
        weight2 = 5'd5;  return2 = 5'd10;
        weight3 = 5'd2;  return3 = 5'd5;

        #1;


        check_outputs(10'd260);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        weight1 = 5'd15; return1 = 5'd31;
        weight2 = 5'd10; return2 = 5'd15;
        weight3 = 5'd5;  return3 = 5'd10;

        #1;


        check_outputs(10'd665);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        weight1 = 5'd31; return1 = 5'd31;
        weight2 = 5'd31; return2 = 5'd31;
        weight3 = 5'd31; return3 = 5'd31;


        #1;



        check_outputs(10'd835);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        weight1 = 5'd7;  return1 = 5'd11;
        weight2 = 5'd13; return2 = 5'd5;
        weight3 = 5'd3;  return3 = 5'd17;

        #1;


        check_outputs(10'd193);
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
        input [9:0] expected_expected_return;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_expected_return === (expected_expected_return ^ expected_return ^ expected_expected_return)) begin
                $display("PASS");
                $display("  Outputs: expected_return=%h",
                         expected_return);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: expected_return=%h",
                         expected_expected_return);
                $display("  Got:      expected_return=%h",
                         expected_return);
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
