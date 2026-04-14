`timescale 1ns/1ps

module portfolio_optimizer_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] investment1;
    reg [15:0] investment2;
    reg [15:0] investment3;
    reg [7:0] weight1;
    reg [7:0] weight2;
    reg [7:0] weight3;
    wire [15:0] total_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    portfolio_optimizer dut (
        .investment1(investment1),
        .investment2(investment2),
        .investment3(investment3),
        .weight1(weight1),
        .weight2(weight2),
        .weight3(weight3),
        .total_value(total_value)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Equal distribution", test_num);
        investment1 = 16'd1000; investment2 = 16'd1000; investment3 = 16'd1000;
        weight1 = 8'd33;       weight2 = 8'd33;       weight3 = 8'd34;

        #1;


        check_outputs(16'd1000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All investments zero", test_num);
        investment1 = 16'd0; investment2 = 16'd0; investment3 = 16'd0;
        weight1 = 8'd50;     weight2 = 8'd25;     weight3 = 8'd25;

        #1;


        check_outputs(16'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All weights zero", test_num);
        investment1 = 16'hFFFF; investment2 = 16'hAAAA; investment3 = 16'h5555;
        weight1 = 8'd0;        weight2 = 8'd0;        weight3 = 8'd0;

        #1;


        check_outputs(16'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 100%% concentration in one asset", test_num);
        investment1 = 16'd5000; investment2 = 16'd2000; investment3 = 16'd1000;
        weight1 = 8'd100;      weight2 = 8'd0;        weight3 = 8'd0;

        #1;


        check_outputs(16'd5000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Large investment values", test_num);
        investment1 = 16'd60000; investment2 = 16'd60000; investment3 = 16'd60000;
        weight1 = 8'd20;        weight2 = 8'd30;        weight3 = 8'd50;

        #1;


        check_outputs(16'd60000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Truncation check (non-integer result)", test_num);
        investment1 = 16'd123; investment2 = 16'd456; investment3 = 16'd789;
        weight1 = 8'd10;      weight2 = 8'd20;      weight3 = 8'd30;

        #1;


        check_outputs(16'd340);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Weights summing to > 100", test_num);
        investment1 = 16'd100; investment2 = 16'd100; investment3 = 16'd100;
        weight1 = 8'd50;      weight2 = 8'd50;      weight3 = 8'd50;

        #1;


        check_outputs(16'd150);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Small investments with varied weights", test_num);
        investment1 = 16'd250; investment2 = 16'd500; investment3 = 16'd750;
        weight1 = 8'd10;      weight2 = 8'd40;      weight3 = 8'd50;

        #1;


        check_outputs(16'd600);
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
        input [15:0] expected_total_value;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_total_value === (expected_total_value ^ total_value ^ expected_total_value)) begin
                $display("PASS");
                $display("  Outputs: total_value=%h",
                         total_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: total_value=%h",
                         expected_total_value);
                $display("  Got:      total_value=%h",
                         total_value);
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
