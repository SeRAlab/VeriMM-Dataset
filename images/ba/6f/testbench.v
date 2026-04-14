`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data_i;
    wire [3:0] data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_i(data_i),
        .data_o(data_o)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: All zeros input", test_num);
        data_i = 4'b0000;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: MSB only", test_num);
        data_i = 4'b1000;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: MSB blocks all lower bits (1111)", test_num);
        data_i = 4'b1111;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: MSB blocks bit 1 (1010)", test_num);
        data_i = 4'b1010;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Bit 2 priority (0100)", test_num);
        data_i = 4'b0100;
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Bit 2 blocks bit 1 and 0 (0111)", test_num);
        data_i = 4'b0111;
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Bit 1 priority (0010)", test_num);
        data_i = 4'b0010;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Bit 1 blocks bit 0 (0011)", test_num);
        data_i = 4'b0011;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Bit 0 priority (0001)", test_num);
        data_i = 4'b0001;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Scattered bits (1001)", test_num);
        data_i = 4'b1001;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Test %0d: Scattered bits (0101)", test_num);
        data_i = 4'b0101;
        #1;

        check_outputs(4'b0100);
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
        input [3:0] expected_data_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_o === (expected_data_o ^ data_o ^ expected_data_o)) begin
                $display("PASS");
                $display("  Outputs: data_o=%h",
                         data_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_o=%h",
                         expected_data_o);
                $display("  Got:      data_o=%h",
                         data_o);
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
