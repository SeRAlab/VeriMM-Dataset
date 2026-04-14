`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data1_in;
    reg [31:0] data2_in;
    wire [31:0] data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data1_in(data1_in),
        .data2_in(data2_in),
        .data_o(data_o)
    );
    task testcase001;

        begin
            test_num = 1;
            data1_in = 32'h00000000;
            data2_in = 32'h00000000;
            $display("Test Case %0d: Adding zero to zero", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            data1_in = 32'h12345678;
            data2_in = 32'h00000000;
            $display("Test Case %0d: Adding zero to a value", test_num);
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            data1_in = 32'h00000001;
            data2_in = 32'h00000001;
            $display("Test Case %0d: Small addition (1+1)", test_num);
            #1;

            check_outputs(32'h00000002);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            data1_in = 32'hFFFFFFFF;
            data2_in = 32'h00000001;
            $display("Test Case %0d: Overflow condition (Max + 1)", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            data1_in = 32'hAAAA_AAAA;
            data2_in = 32'h5555_5555;
            $display("Test Case %0d: Pattern addition (A + 5)", test_num);
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            data1_in = 32'h0000_FFFF;
            data2_in = 32'h0000_0001;
            $display("Test Case %0d: Carry propagation through lower 16 bits", test_num);
            #1;

            check_outputs(32'h0001_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            data1_in = 32'h7FFF_FFFF;
            data2_in = 32'h0000_0001;
            $display("Test Case %0d: Bit 31 transition", test_num);
            #1;

            check_outputs(32'h8000_0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            data1_in = 32'h1234_5678;
            data2_in = 32'h8765_4321;
            $display("Test Case %0d: Arbitrary large numbers", test_num);
            #1;

            check_outputs(32'h9999_9999);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            data1_in = 32'hFFFF_FFFF;
            data2_in = 32'hFFFF_FFFF;
            $display("Test Case %0d: Adding two max values", test_num);
            #1;

            check_outputs(32'hFFFF_FFFE);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            data1_in = 32'hDEAD_BEEF;
            data2_in = 32'h2222_2222;
            $display("Test Case %0d: Random pattern hex", test_num);
            #1;

            check_outputs(32'h00D0_E111);
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
        input [31:0] expected_data_o;
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
