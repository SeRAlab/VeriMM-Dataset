`timescale 1ns/1ps

module adc_interface_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] data_in;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_interface dut (
        .data_in(data_in),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Minimum value (Zero)", test_num);
        data_in = 24'h000000;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Middle of Range 0", test_num);
        data_in = 24'h080000;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Boundary - Just below 1/16", test_num);
        data_in = 24'h0FFFFF;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Boundary - Exactly 1/16", test_num);
        data_in = 24'h100000;
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Middle of Range 1", test_num);
        data_in = 24'h180000;
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Boundary - Just below 1/8", test_num);
        data_in = 24'h1FFFFF;
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Boundary - Exactly 1/8", test_num);
        data_in = 24'h200000;
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Middle of Range 2", test_num);
        data_in = 24'h280000;
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Boundary - Just below 3/16", test_num);
        data_in = 24'h2FFFFF;
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Boundary - Exactly 3/16", test_num);
        data_in = 24'h300000;
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Test %0d: Middle of Range 3", test_num);
        data_in = 24'h380000;
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Test %0d: Boundary - Just below 1/4", test_num);
        data_in = 24'h3FFFFF;
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        $display("Test %0d: Boundary - Exactly 1/4", test_num);
        data_in = 24'h400000;
        #1;

        check_outputs(4'd4);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        $display("Test %0d: Mid-range value (0x800000)", test_num);
        data_in = 24'h800000;
        #1;

        check_outputs(4'd4);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        $display("Test %0d: Maximum 24-bit value", test_num);
        data_in = 24'hFFFFFF;
        #1;

        check_outputs(4'd4);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_interface Testbench");
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
        testcase014();
        testcase015();
        
        
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
