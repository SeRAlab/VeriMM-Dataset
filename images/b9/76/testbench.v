`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [6:0] data;
    wire [2:0] syn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .syn(syn)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All zeros", test_num);
            data = 7'b000_0000;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Single bit at data[0]", test_num);
            data = 7'b000_0001;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Single bit at data[1]", test_num);
            data = 7'b000_0010;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Single bit at data[2]", test_num);
            data = 7'b000_0100;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Single bit at data[3]", test_num);
            data = 7'b000_1000;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Single bit at data[4]", test_num);
            data = 7'b001_0000;
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Single bit at data[5]", test_num);
            data = 7'b010_0000;
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Single bit at data[6]", test_num);
            data = 7'b100_0000;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: All ones", test_num);
            data = 7'b111_1111;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Pattern 1010110", test_num);
            data = 7'b101_0110;



            #1;




            check_outputs(3'b011);
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
        input [2:0] expected_syn;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_syn === (expected_syn ^ syn ^ expected_syn)) begin
                $display("PASS");
                $display("  Outputs: syn=%h",
                         syn);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: syn=%h",
                         expected_syn);
                $display("  Got:      syn=%h",
                         syn);
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
