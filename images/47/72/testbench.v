`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [18:0] i_data;
    wire [25:0] o_data_18;
    wire [25:0] o_data_50;
    wire [25:0] o_data_75;
    wire [25:0] o_data_89;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_data(i_data),
        .o_data_18(o_data_18),
        .o_data_50(o_data_50),
        .o_data_75(o_data_75),
        .o_data_89(o_data_89)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 0", test_num);
            i_data = 19'sd0;
            #1;

            check_outputs(26'sd0, 26'sd0, 26'sd0, 26'sd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 1", test_num);
            i_data = 19'sd1;
            #1;

            check_outputs(26'sd18, 26'sd50, 26'sd75, 26'sd89);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input -1", test_num);
            i_data = -19'sd1;
            #1;

            check_outputs(-26'sd18, -26'sd50, -26'sd75, -26'sd89);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 100", test_num);
            i_data = 19'sd100;
            #1;

            check_outputs(26'sd1800, 26'sd5000, 26'sd7500, 26'sd8900);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input -100", test_num);
            i_data = -19'sd100;
            #1;

            check_outputs(-26'sd1800, -26'sd5000, -26'sd7500, -26'sd8900);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 12345", test_num);
            i_data = 19'sd12345;
            #1;

            check_outputs(26'sd222210, 26'sd617250, 26'sd925875, 26'sd1098705);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input -6789", test_num);
            i_data = -19'sd6789;
            #1;

            check_outputs(-26'sd122202, -26'sd339450, -26'sd509175, -26'sd604221);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Positive Input 262143", test_num);
            i_data = 19'sd262143;
            #1;

            check_outputs(26'sd4718574, 26'sd13107150, 26'sd19660725, 26'sd23330727);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Negative Input -262144", test_num);
            i_data = -19'sd262144;
            #1;

            check_outputs(-26'sd4718592, -26'sd13107200, -26'sd19660800, -26'sd23330816);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 1024", test_num);
            i_data = 19'sd1024;
            #1;

            check_outputs(26'sd18432, 26'sd51200, 26'sd76800, 26'sd91136);
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
        input [25:0] expected_o_data_18;
        input [25:0] expected_o_data_50;
        input [25:0] expected_o_data_75;
        input [25:0] expected_o_data_89;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_data_18 === (expected_o_data_18 ^ o_data_18 ^ expected_o_data_18) &&
                expected_o_data_50 === (expected_o_data_50 ^ o_data_50 ^ expected_o_data_50) &&
                expected_o_data_75 === (expected_o_data_75 ^ o_data_75 ^ expected_o_data_75) &&
                expected_o_data_89 === (expected_o_data_89 ^ o_data_89 ^ expected_o_data_89)) begin
                $display("PASS");
                $display("  Outputs: o_data_18=%h, o_data_50=%h, o_data_75=%h, o_data_89=%h",
                         o_data_18, o_data_50, o_data_75, o_data_89);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_data_18=%h, o_data_50=%h, o_data_75=%h, o_data_89=%h",
                         expected_o_data_18, expected_o_data_50, expected_o_data_75, expected_o_data_89);
                $display("  Got:      o_data_18=%h, o_data_50=%h, o_data_75=%h, o_data_89=%h",
                         o_data_18, o_data_50, o_data_75, o_data_89);
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
