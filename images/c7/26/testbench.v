`timescale 1ns/1ps

module msb_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    msb_module dut (
        .data_in(data_in),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Input all zeros", test_num);
        data_in = 16'h0000;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Input all ones", test_num);
        data_in = 16'hFFFF;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: MSB is 1, LSBs are 0x234", test_num);
        data_in = 16'h1234;
        #1;

        check_outputs(4'h1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: MSB is A, LSBs are 0xBCD", test_num);
        data_in = 16'hABCD;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Boundary check - MSB 7, others 1", test_num);
        data_in = 16'h7FFF;
        #1;

        check_outputs(4'h7);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Boundary check - MSB 8, others 0", test_num);
        data_in = 16'h8000;
        #1;

        check_outputs(4'h8);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Pattern 0101", test_num);
        data_in = 16'h5555;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Pattern 1010", test_num);
        data_in = 16'hAAAA;
        #1;

        check_outputs(4'hA);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("msb_module Testbench");
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
        input [3:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
