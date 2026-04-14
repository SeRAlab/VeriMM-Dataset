`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [59:0] dataa;
    reg [49:0] datab;
    wire [109:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dataa(dataa),
        .datab(datab),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        dataa = 60'sd12345;
        datab = 50'sd6789;
        #1;

        check_outputs($signed(dataa) * $signed(datab));
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        dataa = 60'sd98765;
        datab = -50'sd4321;
        #1;

        check_outputs($signed(dataa) * $signed(datab));
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        dataa = -60'sd555555;
        datab = 50'sd111111;
        #1;

        check_outputs($signed(dataa) * $signed(datab));
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        dataa = -60'sd123456789;
        datab = -50'sd987654321;
        #1;

        check_outputs($signed(dataa) * $signed(datab));
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        dataa = 60'd0;
        datab = 50'sh123456789ABCD;
        #1;

        check_outputs(110'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        dataa = 60'shFFFFFFFFFFFFFFF;
        datab = 50'd0;
        #1;

        check_outputs(110'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        dataa = 60'sh0ABCDEF01234567;
        datab = 50'sd1;
        #1;

        check_outputs($signed(dataa));
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        dataa = 60'sd1000;
        datab = -50'sd1;
        #1;

        check_outputs(-110'sd1000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        dataa = 60'h7FFFFFFFFFFFFFFF;
        datab = 50'h1FFFFFFFFFFFF;
        #1;

        check_outputs($signed(dataa) * $signed(datab));
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        dataa = 60'h800000000000000;
        datab = 50'h2000000000000;
        #1;

        check_outputs($signed(dataa) * $signed(datab));
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        dataa = 60'h7FFFFFFFFFFFFFFF;
        datab = 50'h2000000000000;
        #1;

        check_outputs($signed(dataa) * $signed(datab));
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        dataa = 60'h800000000000000;
        datab = 50'h1FFFFFFFFFFFF;
        #1;

        check_outputs($signed(dataa) * $signed(datab));
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        dataa = 60'h0000_1234_5678_9ABC;
        datab = 50'h000_DEAD_BEEF;
        #1;

        check_outputs($signed(dataa) * $signed(datab));
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
        input [109:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
